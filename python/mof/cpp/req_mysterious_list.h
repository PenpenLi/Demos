#ifndef MOF_REQ_MYSTERIOUS_LIST_H
#define MOF_REQ_MYSTERIOUS_LIST_H

class req_mysterious_list{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void req_mysterious_list(void);
	void encode(ByteArray	&);
	void ~req_mysterious_list();
	void build(ByteArray &);
}
#endif