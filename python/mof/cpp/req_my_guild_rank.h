#ifndef MOF_REQ_MY_GUILD_RANK_H
#define MOF_REQ_MY_GUILD_RANK_H

class req_my_guild_rank{
public:
	void req_my_guild_rank(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_my_guild_rank();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif