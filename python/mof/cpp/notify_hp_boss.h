#ifndef MOF_NOTIFY_HP_BOSS_H
#define MOF_NOTIFY_HP_BOSS_H

class notify_hp_boss{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_hp_boss();
	void notify_hp_boss(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif