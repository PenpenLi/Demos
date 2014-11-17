#ifndef MOF_ACK_GUILD_MEMBER_LIST_H
#define MOF_ACK_GUILD_MEMBER_LIST_H

class ack_guild_member_list{
public:
	void ~ack_guild_member_list();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_guild_member_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif