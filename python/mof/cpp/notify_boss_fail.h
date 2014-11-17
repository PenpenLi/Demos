#ifndef MOF_NOTIFY_BOSS_FAIL_H
#define MOF_NOTIFY_BOSS_FAIL_H

class notify_boss_fail{
public:
	void ~notify_boss_fail();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_boss_fail(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif