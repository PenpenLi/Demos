#ifndef MOF_NOTIFY_SYNC_PVP_START_H
#define MOF_NOTIFY_SYNC_PVP_START_H

class notify_sync_pvp_start{
public:
	void ~notify_sync_pvp_start();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_pvp_start(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif