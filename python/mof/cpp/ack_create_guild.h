#ifndef MOF_ACK_CREATE_GUILD_H
#define MOF_ACK_CREATE_GUILD_H

class ack_create_guild{
public:
	void ack_create_guild(void);
	void PacketName(void);
	void decode(ByteArray &);
	void ~ack_create_guild();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif