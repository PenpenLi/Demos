#ifndef MOF_REQ_GET_ATTACH_H
#define MOF_REQ_GET_ATTACH_H

class req_get_attach{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void ~req_get_attach();
	void req_get_attach(void);
}
#endif