#ifndef MOF_REQ_ENTER_GUILD_TRAIN_ROOM_H
#define MOF_REQ_ENTER_GUILD_TRAIN_ROOM_H

class req_enter_guild_train_room{
public:
	void req_enter_guild_train_room(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_enter_guild_train_room();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif