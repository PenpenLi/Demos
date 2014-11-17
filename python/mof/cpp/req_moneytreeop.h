#ifndef MOF_REQ_MONEYTREEOP_H
#define MOF_REQ_MONEYTREEOP_H

class req_moneytreeop{
public:
	void ~req_moneytreeop();
	void decode(ByteArray &);
	void PacketName(void);
	void req_moneytreeop(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif