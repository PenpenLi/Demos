#ifndef MOF_REQ_LOTTERYSTATE_H
#define MOF_REQ_LOTTERYSTATE_H

class req_lotterystate{
public:
	void ~req_lotterystate();
	void req_lotterystate(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif