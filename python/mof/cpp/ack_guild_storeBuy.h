#ifndef MOF_ACK_GUILD_STOREBUY_H
#define MOF_ACK_GUILD_STOREBUY_H

class ack_guild_storeBuy{
public:
	void ack_guild_storeBuy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_guild_storeBuy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif