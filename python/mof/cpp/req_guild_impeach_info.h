#ifndef MOF_REQ_GUILD_IMPEACH_INFO_H
#define MOF_REQ_GUILD_IMPEACH_INFO_H

class req_guild_impeach_info{
public:
	void req_guild_impeach_info(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_impeach_info();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif