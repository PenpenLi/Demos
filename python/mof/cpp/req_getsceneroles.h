#ifndef MOF_REQ_GETSCENEROLES_H
#define MOF_REQ_GETSCENEROLES_H

class req_getsceneroles{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_getsceneroles(void);
	void ~req_getsceneroles();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif