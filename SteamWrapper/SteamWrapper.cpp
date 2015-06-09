// This is the main DLL file.

#include "stdafx.h"

#include <msclr/marshal.h>
using namespace msclr::interop;

#include "SteamWrapper.h"
using namespace SteamWrapper;


bool SteamCore::RestartViaSteamIfNecessary( uint32 AppId )
{
	bool result = SteamAPI_RestartAppIfNecessary( AppId );
	return result;
}

bool SteamCore::Initialize()
{
	bool success = true;

	if ( !SteamAPI_Init() )
		success = false;
	
	if ( !SteamStats::Initialize() )
		success = false;

	return success;
}

void SteamCore::Shutdown()
{
	SteamAPI_Shutdown();
}

void SteamCore::Update()
{
	SteamAPI_RunCallbacks();
}

System::String^ SteamCore::PlayerName()
{
	ISteamFriends* sf = SteamFriends();
	
	if ( sf != 0 )
	{
		char const * const pchName = sf->GetPersonaName();
		return gcnew System::String( pchName );
	}

	return gcnew System::String( "" );
}

UInt64 SteamCore::PlayerId()
{
	return (uint64)SteamUser()->GetSteamID().GetAccountID();
}

char const * SteamTextInput::GetText()
{
	int cchText = SteamUtils()->GetEnteredGamepadTextLength();
	char * pchText = new char[cchText];

	SteamUtils()->GetEnteredGamepadTextInput( pchText, cchText );

	return pchText;
}

bool SteamTextInput::ShowGamepadTextInput(System::String^ Description, System::String^ InitialText, unsigned int MaxCharacters, Action< bool >^ OnGamepadInputEnd)
{
	s_OnGamepadInputEnd = OnGamepadInputEnd;

	marshal_context context;
	const char* pchDescription = context.marshal_as< const char* >( Description );
	const char* pchInitialText = context.marshal_as< const char* >( InitialText );

	uint64 unCharMax = static_cast<uint64>( MaxCharacters );

	bool val = SteamUtils()->ShowGamepadTextInput( k_EGamepadTextInputModeNormal, k_EGamepadTextInputLineModeSingleLine, pchDescription, unCharMax, pchInitialText );

	return val;
}



CallbackClass::CallbackClass() :
	m_GamepadInputEnded( this, &CallbackClass::OnGamepadInputEnd ),
	m_OnChatMsg( this, &CallbackClass::OnChatMsg ),
	m_OnDataUpdate( this, &CallbackClass::OnDataUpdate ),
	m_OnChatUpdate( this, &CallbackClass::OnChatUpdate ),
	m_CallbackP2PSessionRequest( this, &CallbackClass::OnP2PSessionRequest ),
	m_CallbackP2PSessionConnectFail( this, &CallbackClass::OnP2PSessionConnectFail )
{
}

void CallbackClass::OnGamepadInputEnd( GamepadTextInputDismissed_t * result )
{
	if( SteamTextInput::s_OnGamepadInputEnd != nullptr )
	{
		SteamTextInput::s_OnGamepadInputEnd( result->m_bSubmitted );
	}
}

void CallbackClass::OnFindLeaderboard( LeaderboardFindResult_t *pResult, bool bIOFailure )
{
	LeaderboardHandle handle( pResult->m_hSteamLeaderboard );

	SteamStats::s_OnFind->Invoke( handle, bIOFailure );
}

void CallbackClass::OnLeaderboardDownloadedEntries( LeaderboardScoresDownloaded_t *pLeaderboardScoresDownloaded, bool bIOFailure )
{
	if ( !bIOFailure )
	{
		SteamStats::s_nLeaderboardEntriesFound = min( pLeaderboardScoresDownloaded->m_cEntryCount, 1000 );
   
		for ( int index = 0; index < SteamStats::s_nLeaderboardEntriesFound; index++ )
		{
			SteamUserStats()->GetDownloadedLeaderboardEntry(
				pLeaderboardScoresDownloaded->m_hSteamLeaderboardEntries, index, &m_leaderboardEntries[ index ], NULL, 0 );
		}
	}

	SteamStats::s_OnDownload->Invoke( bIOFailure );
}

void CallbackClass::OnFindLobbies(LobbyMatchList_t *pLobbyMatchList, bool bIOFailure)
{
	if ( !bIOFailure )
	{
		SteamMatches::s_nLobbiesFound = pLobbyMatchList->m_nLobbiesMatching;
	}
	else
	{
		SteamMatches::s_nLobbiesFound = 0;
	}

	SteamMatches::s_OnFindLobbies->Invoke( bIOFailure );
}

void CallbackClass::OnJoinLobby( LobbyEnter_t * pCallback, bool bIOFailure )
{
	if ( !bIOFailure )
	{
		SteamMatches::s_CurrentLobby = SteamLobby( pCallback->m_ulSteamIDLobby );
	}

	SteamMatches::s_OnJoinLobby->Invoke( bIOFailure );
}

void CallbackClass::OnChatUpdate( LobbyChatUpdate_t * pCallback )
{
	if ( SteamMatches::s_OnChatUpdate )
	{
		SteamMatches::s_OnChatUpdate->Invoke();
	}
}

char pvData[4096];
int cubData = sizeof(pvData);
void CallbackClass::OnChatMsg( LobbyChatMsg_t * pCallback )
{
	CSteamID sender;
	EChatEntryType entryType;

	int readed = SteamMatchmaking()->GetLobbyChatEntry( pCallback->m_ulSteamIDLobby, pCallback->m_iChatID,
		&sender, pvData, cubData, &entryType );

	if ( SteamMatches::s_OnChatMsg )
	{
		auto msg = gcnew System::String ( pvData );
		auto id = sender.GetAccountID();
		auto pchName = SteamFriends()->GetFriendPersonaName( sender );
		auto name = gcnew System::String( pchName );

		SteamMatches::s_OnChatMsg->Invoke( msg, id, name );
	}
}

void CallbackClass::OnDataUpdate( LobbyDataUpdate_t * pCallback )
{
	if ( SteamMatches::s_OnDataUpdate )
	{
		SteamMatches::s_OnDataUpdate->Invoke();
	}
}

void CallbackClass::OnLobbyCreated( LobbyCreated_t *pCallback, bool bIOFailure )
{
	if ( !bIOFailure )
	{
		SteamMatches::s_CurrentLobby = SteamLobby( pCallback->m_ulSteamIDLobby );
	}

	SteamMatches::s_OnCreateLobby->Invoke( bIOFailure );
}

void CallbackClass::OnP2PSessionRequest(P2PSessionRequest_t *pP2PSessionRequest)
{
	if ( SteamP2P::OnRequest == nullptr ) return;

	SteamP2P::OnRequest( pP2PSessionRequest->m_steamIDRemote.GetAccountID() );
}

void CallbackClass::OnP2PSessionConnectFail( P2PSessionConnectFail_t *pP2PSessionConnectFail )
{
	if ( SteamP2P::OnConnectionFail == nullptr ) return;

	SteamP2P::OnConnectionFail( pP2PSessionConnectFail->m_steamIDRemote.GetAccountID() );
}

bool SteamStats::Initialize()
{
	g_CallbackClassInstance = new CallbackClass();

	// Is Steam loaded? If not we can't get stats.
	if ( SteamUserStats() == 0 )
	//if ( SteamUserStats() == 0 || SteamUser() == 0 )
	{
		return false;
	}
	// Is the user logged on?  If not we can't get stats.
	//if ( !SteamUser()->BLoggedOn() )
	//{
	//	return false;
	//}
	// Request user stats.
	return SteamUserStats()->RequestCurrentStats();

	return true;
}

bool SteamStats::GiveAchievement( System::String^ AchievementApiName )
{
	marshal_context context;
	const char* pchAchievementApiName = context.marshal_as< const char* >( AchievementApiName );

	bool r = SteamUserStats()->SetAchievement( pchAchievementApiName );
	SteamUserStats()->StoreStats();

	return r;
}

int SteamStats::NumEntries( LeaderboardHandle Handle )
{
	int n = SteamUserStats()->GetLeaderboardEntryCount( Handle.m_handle );
	
	return n;
}

int SteamStats::NumEntriesFound()
{
	return s_nLeaderboardEntriesFound;
}

void SteamStats::FindLeaderboard( System::String^ LeaderboardName, Action< LeaderboardHandle, bool >^ OnFind )
{
	marshal_context context;
	const char* pchLeaderboardName = context.marshal_as< const char* >( LeaderboardName );
	
	SteamStats::s_OnFind = OnFind;

	if( SteamUserStats() == 0 )
	{
		return;
	}

	SteamAPICall_t hSteamAPICall = SteamUserStats()->FindLeaderboard( pchLeaderboardName );
	g_CallResultFindLeaderboard.Set( hSteamAPICall, g_CallbackClassInstance, &CallbackClass::OnFindLeaderboard );
}

void SteamStats::UploadScore( LeaderboardHandle Handle, int Value )
{
	SteamAPICall_t hSteamAPICall = SteamUserStats()->UploadLeaderboardScore( Handle.m_handle, k_ELeaderboardUploadScoreMethodKeepBest, Value, NULL, 0 );
}

void SteamStats::RequestEntries( LeaderboardHandle Handle, int RequestType, int Start, int End, Action< bool >^ OnDownload )
{
	SteamStats::s_OnDownload = OnDownload;

	// Request the specified leaderboard data.
	SteamAPICall_t hSteamAPICall = SteamUserStats()->DownloadLeaderboardEntries(
		Handle.m_handle, static_cast<ELeaderboardDataRequest>( RequestType ), Start, End );

	// Register for the async callback
	g_CallResultDownloadEntries.Set( hSteamAPICall, g_CallbackClassInstance, &CallbackClass::OnLeaderboardDownloadedEntries );
}

int SteamStats::Results_GetScore( int Index )
{
	return m_leaderboardEntries[ Index ].m_nScore;
}

int SteamStats::Results_GetRank( int Index )
{
	return m_leaderboardEntries[ Index ].m_nGlobalRank;
}

const char * SteamStats::Results_GetPlayer( int Index )
{
	const char *pchName = SteamFriends()->GetFriendPersonaName( m_leaderboardEntries[ Index ].m_steamIDUser );
	return pchName;
}

const int SteamStats::Results_GetId( int Index )
{
	return m_leaderboardEntries[ Index ].m_steamIDUser.GetAccountID();
}

void SteamMatches::FindLobbies(Action< bool >^ OnFind)
{
	SteamMatches::s_OnFindLobbies = OnFind;

	if (SteamMatchmaking() == 0)
	{
		return;
	}

	SteamAPICall_t hSteamAPICall = SteamMatchmaking()->RequestLobbyList();
	g_CallResultLobbyMatchList.Set( hSteamAPICall, g_CallbackClassInstance, &CallbackClass::OnFindLobbies );
}

int const SteamMatches::NumLobbies()
{
	return s_nLobbiesFound;
}

System::String^ SteamMatches::GetLobbyData( int Index, System::String^ Key )
{
	CSteamID steamIDLobby = SteamMatchmaking()->GetLobbyByIndex( Index );

	marshal_context context;
	char const * pchKey = context.marshal_as< const char* >( Key );

	char const * pchVal = SteamMatchmaking()->GetLobbyData( steamIDLobby, pchKey );

	if ( pchVal && pchVal[0] )
	{
		return gcnew System::String( pchVal );
	}
	else
	{
		return gcnew System::String( "" );
	}
}

void SteamMatches::JoinCreatedLobby(
	Action< bool >^ OnJoinLobby,
	Action^ OnChatUpdate,
	Action< String^, uint64, String^ >^ OnChatMsg,
	Action^ OnDataUpdate )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	SteamMatches::JoinLobby( *SteamMatches::s_CurrentLobby.m_handle, OnJoinLobby, OnChatUpdate, OnChatMsg, OnDataUpdate );
}

void SteamMatches::JoinLobby( int Index,
	Action< bool >^ OnJoinLobby,
	Action^ OnChatUpdate,
	Action< String^, uint64, String^ >^ OnChatMsg,
	Action^ OnDataUpdate )
{
	CSteamID steamIDLobby = SteamMatchmaking()->GetLobbyByIndex( Index );
	SteamMatches::JoinLobby( steamIDLobby, OnJoinLobby, OnChatUpdate, OnChatMsg, OnDataUpdate );
}

void SteamMatches::JoinLobby( CSteamID LobbyID,
	Action< bool >^ OnJoinLobby,
	Action^ OnChatUpdate,
	Action< String^, uint64, String^ >^ OnChatMsg,
	Action^ OnDataUpdate )
{
	SteamMatches::s_OnJoinLobby = OnJoinLobby;
	SteamMatches::s_OnChatUpdate = OnChatUpdate;
	SteamMatches::s_OnChatMsg = OnChatMsg;
	SteamMatches::s_OnDataUpdate = OnDataUpdate;

	SteamAPICall_t hSteamAPICall = SteamMatchmaking()->JoinLobby( LobbyID );
	g_CallResultJoinLobby.Set( hSteamAPICall, g_CallbackClassInstance, &CallbackClass::OnJoinLobby );
}

ELobbyType IntToLobbyType(int LobbyType)
{
	ELobbyType type = k_ELobbyTypePublic;

	switch (LobbyType)
	{
	case SteamMatches::LobbyType_Public:      type = k_ELobbyTypePublic;      break;
	case SteamMatches::LobbyType_FriendsOnly: type = k_ELobbyTypeFriendsOnly; break;
	case SteamMatches::LobbyType_Private:     type = k_ELobbyTypePrivate;     break;
	}

	return type;
}

void SteamMatches::CreateLobby( Action< bool >^ OnCreateLobby, int LobbyType )
{
	SteamMatches::s_OnCreateLobby = OnCreateLobby;

	ELobbyType type = IntToLobbyType( LobbyType );

	SteamAPICall_t hSteamAPICall = SteamMatchmaking()->CreateLobby( type, 4 );
	g_CallResultLobbyCreated.Set( hSteamAPICall, g_CallbackClassInstance, &CallbackClass::OnLobbyCreated );
}

void SteamMatches::SetLobbyData( System::String^ Key, System::String^ Value )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	marshal_context context;
	const char* pchKey = context.marshal_as< const char* >( Key );
	const char* pchVal = context.marshal_as< const char* >( Value );

	SteamMatchmaking()->SetLobbyData( *SteamMatches::s_CurrentLobby.m_handle, pchKey, pchVal );
}

System::String^ SteamMatches::GetLobbyData( System::String^ Key )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return gcnew System::String("");

	marshal_context context;
	char const * pchKey = context.marshal_as< char const * >( Key );

	char const * pchVal = SteamMatchmaking()->GetLobbyData( *SteamMatches::s_CurrentLobby.m_handle, pchKey );
	
	return gcnew System::String ( pchVal );
}

int SteamMatches::GetLobbyMemberCount( int Index )
{
	CSteamID steamIDLobby = SteamMatchmaking()->GetLobbyByIndex( Index );
	return SteamMatchmaking()->GetNumLobbyMembers( steamIDLobby );
}

int SteamMatches::GetLobbyCapacity( int Index )
{
	CSteamID steamIDLobby = SteamMatchmaking()->GetLobbyByIndex( Index );
	return SteamMatchmaking()->GetLobbyMemberLimit( steamIDLobby );
}

void SteamMatches::SetLobbyType( int LobbyType )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	ELobbyType type = IntToLobbyType( LobbyType );
	SteamMatchmaking()->SetLobbyType( *SteamMatches::s_CurrentLobby.m_handle, type );
}

void SteamMatches::SendChatMsg( System::String^ Msg )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	marshal_context context;
	char const * pchMsg = context.marshal_as< char const * >( Msg );

	SteamMatchmaking()->SendLobbyChatMsg( *SteamMatches::s_CurrentLobby.m_handle, pchMsg, Msg->Length + 1 );
}

int SteamMatches::GetLobbyMemberCount()
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return -1;
	return SteamMatchmaking()->GetNumLobbyMembers( *SteamMatches::s_CurrentLobby.m_handle );
}

String^ SteamMatches::GetMememberName( int Index )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return gcnew System::String("");
	
	CSteamID steamIDLobbyMember = SteamMatchmaking()->GetLobbyMemberByIndex( *SteamMatches::s_CurrentLobby.m_handle, Index );

	char const * const pchName = SteamFriends()->GetFriendPersonaName( steamIDLobbyMember );
	return gcnew System::String( pchName );
}

UInt64 SteamMatches::GetMememberId( int Index )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return 0;
	
	CSteamID steamIDLobbyMember = SteamMatchmaking()->GetLobbyMemberByIndex( *SteamMatches::s_CurrentLobby.m_handle, Index );

	return (uint64)steamIDLobbyMember.GetAccountID();
}

bool SteamMatches::IsLobbyOwner()
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return false;
	return SteamUser()->GetSteamID() == SteamMatchmaking()->GetLobbyOwner( *SteamMatches::s_CurrentLobby.m_handle );
}

void SteamMatches::LeaveLobby()
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	SteamMatchmaking()->LeaveLobby( *SteamMatches::s_CurrentLobby.m_handle );
	SteamMatches::s_CurrentLobby.m_handle = NULL;
}

void SteamMatches::SetLobbyJoinable( bool Joinable )
{
	if ( SteamMatches::s_CurrentLobby.m_handle == NULL ) return;

	SteamMatchmaking()->SetLobbyJoinable( *SteamMatches::s_CurrentLobby.m_handle, Joinable );
}

void SteamP2P::SendMessage( SteamPlayer User, String^ Message )
{
	SendMessage( *User.m_handle, Message );
}

void SteamP2P::SendMessage( CSteamID User, String^ Message )
{
	marshal_context context;
	char const * pchMsg = context.marshal_as< char const * >( Message );

	SteamNetworking()->SendP2PPacket( User, pchMsg, Message->Length, k_EP2PSendReliable );
}

bool SteamP2P::MessageAvailable()
{
	uint32 msgSize = 0;
	bool result = SteamNetworking()->IsP2PPacketAvailable( &msgSize );
	
	return result;
}

String^ SteamP2P::ReadMessage()
{
	uint32 msgSize = 0;
	bool result = SteamNetworking()->IsP2PPacketAvailable( &msgSize );

	if ( !result ) {
		return nullptr;
	}

	char * packet = (char *)malloc( msgSize );
	CSteamID steamIDRemote;
	uint32 bytesRead = 0;
	
	String^ msg = nullptr;
	if ( SteamNetworking()->ReadP2PPacket( packet, msgSize, &bytesRead, &steamIDRemote ) )
	{
		msg = gcnew System::String( packet );
	}
	
	free( packet );

	return msg;
}

void SteamP2P::SetOnP2PSessionRequest(Action< uint64 >^ OnRequest)
{
	SteamP2P::OnRequest = OnRequest;
}

void SteamP2P::SetOnP2PSessionConnectFail(Action< uint64 >^ OnConnectionFail)
{
	SteamP2P::OnConnectionFail = OnConnectionFail;
}

void SteamP2P::AcceptP2PSessionWithPlayer( SteamPlayer Player )
{
	SteamNetworking()->AcceptP2PSessionWithUser( *Player.m_handle );
}