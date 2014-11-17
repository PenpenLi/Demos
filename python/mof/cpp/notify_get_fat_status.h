#ifndef MOF_NOTIFY_GET_FAT_STATUS_H
#define MOF_NOTIFY_GET_FAT_STATUS_H

class notify_get_fat_status{
public:
	void ~notify_get_fat_status();
	void notify_get_fat_status(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif