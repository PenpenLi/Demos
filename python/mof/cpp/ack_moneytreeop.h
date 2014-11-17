#ifndef MOF_ACK_MONEYTREEOP_H
#define MOF_ACK_MONEYTREEOP_H

class ack_moneytreeop{
public:
	void ~ack_moneytreeop();
	void ack_moneytreeop(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif