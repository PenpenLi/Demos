#ifndef MOF_NOTIFY_SYNC_DAMAGE_H
#define MOF_NOTIFY_SYNC_DAMAGE_H

class notify_sync_damage{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_damage(void);
	void ~notify_sync_damage();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif