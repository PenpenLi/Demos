#ifndef MOF_REQ_PUTON_FASHION_H
#define MOF_REQ_PUTON_FASHION_H

class req_puton_fashion{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_puton_fashion();
	void req_puton_fashion(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif