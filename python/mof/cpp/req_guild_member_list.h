#ifndef MOF_REQ_GUILD_MEMBER_LIST_H
#define MOF_REQ_GUILD_MEMBER_LIST_H

class req_guild_member_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_guild_member_list(void);
	void ~req_guild_member_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif