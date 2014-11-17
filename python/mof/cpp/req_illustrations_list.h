#ifndef MOF_REQ_ILLUSTRATIONS_LIST_H
#define MOF_REQ_ILLUSTRATIONS_LIST_H

class req_illustrations_list{
public:
	void req_illustrations_list(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_illustrations_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif