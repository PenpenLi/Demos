#ifndef MOF_REQ_DAILY_GET_FAT_H
#define MOF_REQ_DAILY_GET_FAT_H

class req_daily_get_fat{
public:
	void req_daily_get_fat(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_daily_get_fat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif