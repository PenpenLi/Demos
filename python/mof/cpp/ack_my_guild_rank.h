#ifndef MOF_ACK_MY_GUILD_RANK_H
#define MOF_ACK_MY_GUILD_RANK_H

class ack_my_guild_rank{
public:
	void ack_my_guild_rank(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_my_guild_rank();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif