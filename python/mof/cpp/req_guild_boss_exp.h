#ifndef MOF_REQ_GUILD_BOSS_EXP_H
#define MOF_REQ_GUILD_BOSS_EXP_H

class req_guild_boss_exp{
public:
	void req_guild_boss_exp(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_guild_boss_exp();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif