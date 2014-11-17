#ifndef MOF_ACK_N_LOTTERY_H
#define MOF_ACK_N_LOTTERY_H

class ack_n_lottery{
public:
	void ack_n_lottery(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_n_lottery();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif