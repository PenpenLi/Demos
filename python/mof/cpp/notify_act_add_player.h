#ifndef MOF_NOTIFY_ACT_ADD_PLAYER_H
#define MOF_NOTIFY_ACT_ADD_PLAYER_H

class notify_act_add_player{
public:
	void ~notify_act_add_player();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_act_add_player(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif