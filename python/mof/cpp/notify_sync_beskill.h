#ifndef MOF_NOTIFY_SYNC_BESKILL_H
#define MOF_NOTIFY_SYNC_BESKILL_H

class notify_sync_beskill{
public:
	void notify_sync_beskill(void);
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void ~notify_sync_beskill();
	void build(ByteArray &);
}
#endif