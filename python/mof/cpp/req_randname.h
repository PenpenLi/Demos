#ifndef MOF_REQ_RANDNAME_H
#define MOF_REQ_RANDNAME_H

class req_randname{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_randname(void);
	void ~req_randname();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif