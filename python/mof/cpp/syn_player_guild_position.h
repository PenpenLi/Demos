#ifndef MOF_SYN_PLAYER_GUILD_POSITION_H
#define MOF_SYN_PLAYER_GUILD_POSITION_H

class syn_player_guild_position{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~syn_player_guild_position();
	void syn_player_guild_position(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif