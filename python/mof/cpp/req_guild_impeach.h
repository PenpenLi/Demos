#ifndef MOF_REQ_GUILD_IMPEACH_H
#define MOF_REQ_GUILD_IMPEACH_H

class req_guild_impeach{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_impeach(void);
	void ~req_guild_impeach();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif