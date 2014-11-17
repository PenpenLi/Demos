#ifndef MOF_NOTIFY_SYNC_FRESH_PAIHANG_H
#define MOF_NOTIFY_SYNC_FRESH_PAIHANG_H

class notify_sync_fresh_paihang{
public:
	void notify_sync_fresh_paihang(void);
	void PacketName(void);
	void ~notify_sync_fresh_paihang();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif