#ifndef MOF_REQ_LOTTERY_H
#define MOF_REQ_LOTTERY_H

class req_lottery{
public:
	void decode(ByteArray	&);
	void ~req_lottery();
	void PacketName(void);
	void encode(ByteArray	&);
	void req_lottery(void);
	void build(ByteArray &);
}
#endif