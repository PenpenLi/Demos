#ifndef MOF_REQ_N_LOTTERY_H
#define MOF_REQ_N_LOTTERY_H

class req_n_lottery{
public:
	void req_n_lottery(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_n_lottery();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif