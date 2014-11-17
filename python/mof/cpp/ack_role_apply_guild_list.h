#ifndef MOF_ACK_ROLE_APPLY_GUILD_LIST_H
#define MOF_ACK_ROLE_APPLY_GUILD_LIST_H

class ack_role_apply_guild_list{
public:
	void ~ack_role_apply_guild_list();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_role_apply_guild_list(void);
}
#endif