#ifndef MOF_ACK_GUILD_LIST_H
#define MOF_ACK_GUILD_LIST_H

class ack_guild_list{
public:
	void ~ack_guild_list();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_guild_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif