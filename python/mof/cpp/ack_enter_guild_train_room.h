#ifndef MOF_ACK_ENTER_GUILD_TRAIN_ROOM_H
#define MOF_ACK_ENTER_GUILD_TRAIN_ROOM_H

class ack_enter_guild_train_room{
public:
	void decode(ByteArray &);
	void ack_enter_guild_train_room(void);
	void PacketName(void);
	void ~ack_enter_guild_train_room();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif