#ifndef MOF_SYN_PLAYER_GUILD_CONSTRIB_H
#define MOF_SYN_PLAYER_GUILD_CONSTRIB_H

class syn_player_guild_constrib{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void syn_player_guild_constrib(void);
	void ~syn_player_guild_constrib();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif