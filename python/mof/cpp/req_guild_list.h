#ifndef MOF_REQ_GUILD_LIST_H
#define MOF_REQ_GUILD_LIST_H

class req_guild_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_list(void);
	void ~req_guild_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif