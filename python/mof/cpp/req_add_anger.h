#ifndef MOF_REQ_ADD_ANGER_H
#define MOF_REQ_ADD_ANGER_H

class req_add_anger{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_add_anger(void);
	void ~req_add_anger();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif