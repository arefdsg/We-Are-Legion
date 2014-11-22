using System;
using System.IO;

using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Collections.Generic;
using System.Collections.Concurrent;

using FragSharpHelper;
using FragSharpFramework;

namespace Terracotta
{
    public class Client
    {
        TcpClient client = null;
        NetworkStream stream = null;
        byte[] bytes = new byte[1 << 16];

        void ReceiveThread()
        {
            while (true)
            {
                if (stream.DataAvailable)
                {
                    var messages = stream.Receive(bytes);

                    foreach (var message in messages)
                    {
                        Networking.Inbox.Enqueue(message);
                        Console.WriteLine("(Client) Received: {0}", message);
                    }
                }
            }
        }

        void SendThread()
        {
            Tuple<int, string> message = null;

            while (true)
            {
                if (Networking.Outbox.TryDequeue(out message))
                {
                    stream.Send(message.Item2);
                    Console.WriteLine("(Client) Sent: {0}", message.Item2);
                }

                Thread.SpinWait(1);
            }
        }

        public Client()
        {
            try
            {
                Int32 port = 13000;
                IPAddress server_addr = IPAddress.Parse("127.0.0.1");

                client = new TcpClient();

                Console.Write("Waiting to connect... ");
                client.Connect(server_addr, port);
                Console.WriteLine("Connected!");

                stream = client.GetStream();

                new Thread(ReceiveThread).Start();
                new Thread(SendThread).Start();
            }
            catch (ArgumentNullException e)
            {
                Console.WriteLine("ArgumentNullException: {0}", e);
                stream.Close();
                client.Close();
            }
            catch (SocketException e)
            {
                Console.WriteLine("SocketException: {0}", e);
                stream.Close();
                client.Close();
            }
        }
    }

    public class Server
    {
        TcpListener server = null;
        TcpClient client = null;
        NetworkStream stream = null;
        byte[] bytes = new byte[1 << 16];

        void ReceiveThread()
        {
            while (true)
            {
                Thread.Sleep(1000);

                if (stream.DataAvailable)
                {
                    var messages = stream.Receive(bytes);

                    foreach (var message in messages)
                    {
                        Console.WriteLine("(Server) Received: {0}", message);
                        Networking.Inbox.Enqueue(message);
                    }
                }
            }
        }

        void SendThread()
        {
            Tuple<int, string> message = null;

            while (true)
            {
                if (Networking.Outbox.TryDequeue(out message))
                {
                    if (message.Item1 == 0)
                    {
                        Networking.Inbox.Enqueue(message.Item2);
                    }
                    else
                    {
                        stream.Send(message.Item2);
                    }

                    Console.WriteLine("(Server) Sent to {1}: {0}", message.Item2, message.Item1);
                }

                Thread.SpinWait(1);
            }
        }

        public Server()
        {
            try
            {
                Int32 port = 13000;
                IPAddress local_addr = IPAddress.Parse("127.0.0.1");

                server = new TcpListener(local_addr, port);
                server.Start();

                Console.Write("Waiting for a connection... ");
                client = server.AcceptTcpClient();
                Console.WriteLine("Connected!");

                stream = client.GetStream();

                new Thread(ReceiveThread).Start();
                new Thread(SendThread).Start();
            }
            catch (ArgumentNullException e)
            {
                Console.WriteLine("ArgumentNullException: {0}", e);
                server.Stop();
                stream.Close();
                client.Close();
            }
            catch (SocketException e)
            {
                Console.WriteLine("SocketException: {0}", e);
                server.Stop();
                stream.Close();
                client.Close();
            }
        }
    }

    public enum MessageType { PlayerAction, PlayerActionAck, EndOfStep }
    public enum PlayerAction { Select, Attack }


    public class Message
    {
        public string MyString = "";

        static string sep = " ";
        public static string s<T>(T v)
        {
            return v.ToString() + sep;
        }

        public Message(string str)
        {
            MyString = str;
        }

        public static Message operator |(Message m, MessageType t)
        {
            return new Message(m.MyString + s(t));
        }

        public static Message operator |(Message m, PlayerAction t)
        {
            return new Message(m.MyString + s(t));
        }

        public static Message operator |(Message m, string str)
        {
            return new Message(m.MyString + str);
        }

        public static Message operator |(Message m, vec2 v)
        {
            return new Message(m.MyString + s(v));
        }

        public static Message operator |(Message m, int v)
        {
            return new Message(m.MyString + s(v));
        }

        public static implicit operator string(Message m)
        {
            return m.MyString;
        }
    }

    public static class Networking
    {
        public static ConcurrentQueue<string>
            Inbox  = new ConcurrentQueue<string>();

        public static ConcurrentQueue<Tuple<int, string>>
            Outbox = new ConcurrentQueue<Tuple<int, string>>();

        static Message _ = new Message("");

        public static void ToClients_PlayerActionAck(string message)
        {
            var msg = _ | MessageType.PlayerActionAck | message;

            ToClients(msg);
        }

        public static void ToServer_Select(vec2 v1, vec2 v2)
        {
            ToServer(_ | MessageType.PlayerAction | GameClass.World.SimStep | GameClass.World.PlayerNumber | PlayerAction.Select | v1 | v2);
        }

        public static void Parse()
        { 
            
        }

        public static void ToServer(string message)
        {
            Outbox.Enqueue(new Tuple<int, string>(0, message));
        }

        public static void ToClients(string message)
        {
            if (Program.Server)
            {
                Outbox.Enqueue(new Tuple<int, string>(1, message));
            }
            else
            {
                throw new Exception("Clients cannot send messages to clients.");
            }
        }

        public static void Start()
        {
            if (Program.Server) new Server();
            if (Program.Client) new Client();
        }

        public static bool Send(this NetworkStream stream, string message)
        {
            try
            {
                var bytes = Encoding.ASCII.GetBytes(message + '|');
                stream.Write(bytes, 0, bytes.Length);

                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        public static List<string> Receive(this NetworkStream stream, byte[] scratch)
        {
            Int32 bytes_read = stream.Read(scratch, 0, 1 << 16);
            string data = Encoding.ASCII.GetString(scratch, 0, bytes_read);

            var messages = new List<string>(data.Split('|'));

            if (messages.Count <= 1) return messages;
            else return messages.GetRange(0, messages.Count - 1);
        }
    }
}