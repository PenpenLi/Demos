#ifndef MOF_REQ_QUERYROLE_H
#define MOF_REQ_QUERYROLE_H

class req_queryrole{
public:
	void req_queryrole(void);
	void ~req_queryrole();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif