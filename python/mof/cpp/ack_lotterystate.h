#ifndef MOF_ACK_LOTTERYSTATE_H
#define MOF_ACK_LOTTERYSTATE_H

class ack_lotterystate{
public:
	void ack_lotterystate(void);
	void ~ack_lotterystate();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif