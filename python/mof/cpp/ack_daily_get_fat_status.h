#ifndef MOF_ACK_DAILY_GET_FAT_STATUS_H
#define MOF_ACK_DAILY_GET_FAT_STATUS_H

class ack_daily_get_fat_status{
public:
	void ~ack_daily_get_fat_status();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_daily_get_fat_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif