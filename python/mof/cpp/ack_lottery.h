#ifndef MOF_ACK_LOTTERY_H
#define MOF_ACK_LOTTERY_H

class ack_lottery{
public:
	void decode(ByteArray	&);
	void ~ack_lottery();
	void ack_lottery(void);
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif