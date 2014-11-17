#ifndef MOF_NOTIFY_SYNC_CHANGESPEED_H
#define MOF_NOTIFY_SYNC_CHANGESPEED_H

class notify_sync_changespeed{
public:
	void ~notify_sync_changespeed();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_changespeed(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif