#ifndef MOF_REQ_SORTBAG_H
#define MOF_REQ_SORTBAG_H

class req_sortbag{
public:
	void decode(ByteArray	&);
	void req_sortbag(void);
	void PacketName(void);
	void ~req_sortbag();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif