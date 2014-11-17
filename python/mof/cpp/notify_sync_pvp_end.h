#ifndef MOF_NOTIFY_SYNC_PVP_END_H
#define MOF_NOTIFY_SYNC_PVP_END_H

class notify_sync_pvp_end{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~notify_sync_pvp_end();
	void encode(ByteArray	&);
	void notify_sync_pvp_end(void);
	void build(ByteArray &);
}
#endif