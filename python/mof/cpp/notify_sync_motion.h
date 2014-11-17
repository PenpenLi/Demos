#ifndef MOF_NOTIFY_SYNC_MOTION_H
#define MOF_NOTIFY_SYNC_MOTION_H

class notify_sync_motion{
public:
	void notify_sync_motion(void);
	void PacketName(void);
	void ~notify_sync_motion();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif