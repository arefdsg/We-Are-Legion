using FragSharpFramework;

namespace GpuSim
{
    public partial class SpawnUnits : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<unit> Unit, Field<data> CurrentData, Field<data> PreviousData, Field<vec4> Random)
        {
            data
                cur_data = CurrentData[Here],
                prev_data = PreviousData[Here];

            vec4 rnd = Random[Here];

            if (rnd.x > .93 && !Something(cur_data) && !Something(prev_data))
            {
                unit
                    unit_right = Unit[RightOne],
                    unit_up = Unit[UpOne],
                    unit_left = Unit[LeftOne],
                    unit_down = Unit[DownOne];

                data
                    data_right = PreviousData[RightOne],
                    data_up = PreviousData[UpOne],
                    data_left = PreviousData[LeftOne],
                    data_down = PreviousData[DownOne];

                float spawn_dir = Dir.None;

                // Spawn units on the side of the barracks facing the target they are headed toward
                //if (unit_left.type == UnitType.Barracks && prior_direction(data_left) == Dir.Right) spawn_dir = Dir.Right;
                //if (unit_right.type == UnitType.Barracks && prior_direction(data_right) == Dir.Left) spawn_dir = Dir.Left;
                //if (unit_up.type == UnitType.Barracks && prior_direction(data_up) == Dir.Down) spawn_dir = Dir.Down;
                //if (unit_down.type == UnitType.Barracks && prior_direction(data_down) == Dir.Up) spawn_dir = Dir.Up;

                // Spawn units anywhere adjacent to the barracks
                if (unit_left.type == UnitType.Barracks) spawn_dir = Dir.Right;
                if (unit_right.type == UnitType.Barracks) spawn_dir = Dir.Left;
                if (unit_up.type == UnitType.Barracks) spawn_dir = Dir.Down;
                if (unit_down.type == UnitType.Barracks) spawn_dir = Dir.Up;
                

                if (IsValid(spawn_dir))
                {
                    cur_data.direction = spawn_dir;
                    cur_data.action = UnitAction.Spawning;
                    cur_data.change = Change.Stayed;
                    set_selected(ref cur_data, false);
                    set_prior_direction(ref cur_data, cur_data.direction);
                }
            }

            return cur_data;
        }
    }

    public partial class SetSpawn_Unit : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, Field<unit> Unit, Field<data> Data)
        {
            data data_here = Data[Here];
            unit unit_here = Unit[Here];

            if (Something(data_here) && data_here.action == UnitAction.Spawning)
            {
                unit barracks = Unit[dir_to_vec(Reverse(data_here.direction))];
                unit_here.player = barracks.player;
                unit_here.team   = barracks.team;
                unit_here.type   = UnitType.Footman;
                unit_here.anim   = Anim.Stand;
            }

            return unit_here;
        }
    }

    public partial class SetSpawn_Target : SimShader
    {
        [FragmentShader]
        vec4 FragmentShader(VertexOut vertex, Field<vec4> Target, Field<data> Data, Field<vec4> Random)
        {
            data data_here = Data[Here];
            vec4 target = Target[Here];

            if (Something(data_here) && data_here.action == UnitAction.Spawning)
            {
                target = Target[dir_to_vec(Reverse(data_here.direction))];

                //vec4 rnd = Random[Here];
                //target.y += rnd.x * _50 - _25;
                //target.w += rnd.y * _50 - _25;
            }

            return target;
        }
    }

    public partial class SetSpawn_Data : SimShader
    {
        [FragmentShader]
        data FragmentShader(VertexOut vertex, Field<unit> Unit, Field<data> Data)
        {
            data data_here = Data[Here];
            unit unit_here = Unit[Here];

            if (Something(data_here) && data_here.action == UnitAction.Spawning)
            {
                data_here.action = UnitAction.Attacking;
            }

            return data_here;
        }
    }
}
