#ifndef MOF_REQ_CONSTELLUPG_H
#define MOF_REQ_CONSTELLUPG_H

class req_constellupg{
public:
	void req_constellupg(void);
	void decode(ByteArray &);
	void ~req_constellupg();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif