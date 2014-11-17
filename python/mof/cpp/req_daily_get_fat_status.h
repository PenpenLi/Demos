#ifndef MOF_REQ_DAILY_GET_FAT_STATUS_H
#define MOF_REQ_DAILY_GET_FAT_STATUS_H

class req_daily_get_fat_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_daily_get_fat_status(void);
	void ~req_daily_get_fat_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif