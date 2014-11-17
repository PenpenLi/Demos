#ifndef MOF_REQ_TRAIN_GUILD_BOSS_H
#define MOF_REQ_TRAIN_GUILD_BOSS_H

class req_train_guild_boss{
public:
	void req_train_guild_boss(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ~req_train_guild_boss();
	void encode(ByteArray &);
}
#endif