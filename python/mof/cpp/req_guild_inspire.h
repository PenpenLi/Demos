#ifndef MOF_REQ_GUILD_INSPIRE_H
#define MOF_REQ_GUILD_INSPIRE_H

class req_guild_inspire{
public:
	void req_guild_inspire(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_inspire();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif