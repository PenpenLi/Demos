#ifndef MOF_NOTIFY_FRIEND_STATE_REFRESH_H
#define MOF_NOTIFY_FRIEND_STATE_REFRESH_H

class notify_friend_state_refresh{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void notify_friend_state_refresh(void);
	void ~notify_friend_state_refresh();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif