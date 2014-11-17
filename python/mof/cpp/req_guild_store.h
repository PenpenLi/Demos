#ifndef MOF_REQ_GUILD_STORE_H
#define MOF_REQ_GUILD_STORE_H

class req_guild_store{
public:
	void ~req_guild_store();
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_store(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif