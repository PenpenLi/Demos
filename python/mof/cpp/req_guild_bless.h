#ifndef MOF_REQ_GUILD_BLESS_H
#define MOF_REQ_GUILD_BLESS_H

class req_guild_bless{
public:
	void ~req_guild_bless();
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_bless(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif