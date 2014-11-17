#ifndef MOF_ACK_DAILY_GET_FAT_H
#define MOF_ACK_DAILY_GET_FAT_H

class ack_daily_get_fat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_daily_get_fat();
	void ack_daily_get_fat(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif