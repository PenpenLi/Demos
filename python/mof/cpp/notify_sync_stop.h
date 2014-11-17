#ifndef MOF_NOTIFY_SYNC_STOP_H
#define MOF_NOTIFY_SYNC_STOP_H

class notify_sync_stop{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_stop(void);
	void ~notify_sync_stop();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif