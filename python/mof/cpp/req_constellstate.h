#ifndef MOF_REQ_CONSTELLSTATE_H
#define MOF_REQ_CONSTELLSTATE_H

class req_constellstate{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_constellstate();
	void req_constellstate(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif