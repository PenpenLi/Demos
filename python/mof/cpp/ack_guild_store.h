#ifndef MOF_ACK_GUILD_STORE_H
#define MOF_ACK_GUILD_STORE_H

class ack_guild_store{
public:
	void decode(ByteArray &);
	void ~ack_guild_store();
	void ack_guild_store(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif