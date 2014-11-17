#ifndef MOF_ACK_MONEYTREESTATE_H
#define MOF_ACK_MONEYTREESTATE_H

class ack_moneytreestate{
public:
	void ack_moneytreestate(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_moneytreestate();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif