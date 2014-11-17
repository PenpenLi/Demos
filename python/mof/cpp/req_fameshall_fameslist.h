#ifndef MOF_REQ_FAMESHALL_FAMESLIST_H
#define MOF_REQ_FAMESHALL_FAMESLIST_H

class req_fameshall_fameslist{
public:
	void decode(ByteArray &);
	void req_fameshall_fameslist(void);
	void PacketName(void);
	void ~req_fameshall_fameslist();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif