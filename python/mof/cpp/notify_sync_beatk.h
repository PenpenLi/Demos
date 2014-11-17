#ifndef MOF_NOTIFY_SYNC_BEATK_H
#define MOF_NOTIFY_SYNC_BEATK_H

class notify_sync_beatk{
public:
	void ~notify_sync_beatk();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_beatk(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif