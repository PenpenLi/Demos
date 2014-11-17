#ifndef MOF_REQ_GUILD_INFO_H
#define MOF_REQ_GUILD_INFO_H

class req_guild_info{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_info();
	void req_guild_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif