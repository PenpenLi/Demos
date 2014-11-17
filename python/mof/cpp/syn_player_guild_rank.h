#ifndef MOF_SYN_PLAYER_GUILD_RANK_H
#define MOF_SYN_PLAYER_GUILD_RANK_H

class syn_player_guild_rank{
public:
	void ~syn_player_guild_rank();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void syn_player_guild_rank(void);
}
#endif