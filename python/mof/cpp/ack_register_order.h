#ifndef MOF_ACK_REGISTER_ORDER_H
#define MOF_ACK_REGISTER_ORDER_H

class ack_register_order{
public:
	void ack_register_order(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_register_order();
}
#endif