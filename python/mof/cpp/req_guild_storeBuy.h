#ifndef MOF_REQ_GUILD_STOREBUY_H
#define MOF_REQ_GUILD_STOREBUY_H

class req_guild_storeBuy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_storeBuy(void);
	void ~req_guild_storeBuy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif