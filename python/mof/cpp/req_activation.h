#ifndef MOF_REQ_ACTIVATION_H
#define MOF_REQ_ACTIVATION_H

class req_activation{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_activation(void);
	void ~req_activation();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif