#ifndef MOF_ACK_GUILD_LEAVE_H
#define MOF_ACK_GUILD_LEAVE_H

class ack_guild_leave{
public:
	void PacketName(void);
	void ack_guild_leave(void);
	void ~ack_guild_leave();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif