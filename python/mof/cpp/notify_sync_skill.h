#ifndef MOF_NOTIFY_SYNC_SKILL_H
#define MOF_NOTIFY_SYNC_SKILL_H

class notify_sync_skill{
public:
	void notify_sync_skill(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_sync_skill();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif