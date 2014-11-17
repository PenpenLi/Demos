#ifndef MOF_ACK_TRAIN_GUILD_BOSS_H
#define MOF_ACK_TRAIN_GUILD_BOSS_H

class ack_train_guild_boss{
public:
	void ~ack_train_guild_boss();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_train_guild_boss(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif