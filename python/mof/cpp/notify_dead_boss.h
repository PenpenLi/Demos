#ifndef MOF_NOTIFY_DEAD_BOSS_H
#define MOF_NOTIFY_DEAD_BOSS_H

class notify_dead_boss{
public:
	void ~notify_dead_boss();
	void PacketName(void);
	void notify_dead_boss(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif