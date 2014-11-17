#ifndef MOF_NTY_GUILD_BOSS_EXP_H
#define MOF_NTY_GUILD_BOSS_EXP_H

class nty_guild_boss_exp{
public:
	void nty_guild_boss_exp(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~nty_guild_boss_exp();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif