#ifndef MOF_REQ_ROLE_APPLY_GUILD_LIST_H
#define MOF_REQ_ROLE_APPLY_GUILD_LIST_H

class req_role_apply_guild_list{
public:
	void ~req_role_apply_guild_list();
	void decode(ByteArray &);
	void PacketName(void);
	void req_role_apply_guild_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif