#ifndef MOF_ACK_BUY_FAT_H
#define MOF_ACK_BUY_FAT_H

class ack_buy_fat{
public:
	void decode(ByteArray	&);
	void ~ack_buy_fat();
	void PacketName(void);
	void encode(ByteArray	&);
	void ack_buy_fat(void);
	void build(ByteArray &);
}
#endif