#ifndef MOF_ACK_LEAVE_GUILD_TRAIN_ROOM_H
#define MOF_ACK_LEAVE_GUILD_TRAIN_ROOM_H

class ack_leave_guild_train_room{
public:
	void ack_leave_guild_train_room(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_leave_guild_train_room();
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif