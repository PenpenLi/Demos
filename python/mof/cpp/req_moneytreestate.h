#ifndef MOF_REQ_MONEYTREESTATE_H
#define MOF_REQ_MONEYTREESTATE_H

class req_moneytreestate{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_moneytreestate();
	void req_moneytreestate(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif