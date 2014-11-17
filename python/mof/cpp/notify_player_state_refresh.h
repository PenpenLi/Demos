#ifndef MOF_NOTIFY_PLAYER_STATE_REFRESH_H
#define MOF_NOTIFY_PLAYER_STATE_REFRESH_H

class notify_player_state_refresh{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~notify_player_state_refresh();
	void encode(ByteArray	&);
	void build(ByteArray &);
	void notify_player_state_refresh(void);
}
#endif