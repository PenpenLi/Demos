#ifndef MOF_REQ_REGISTER_ORDER_H
#define MOF_REQ_REGISTER_ORDER_H

class req_register_order{
public:
	void req_register_order(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_register_order();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif