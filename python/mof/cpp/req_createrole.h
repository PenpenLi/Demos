#ifndef MOF_REQ_CREATEROLE_H
#define MOF_REQ_CREATEROLE_H

class req_createrole{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_createrole(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void ~req_createrole();
}
#endif