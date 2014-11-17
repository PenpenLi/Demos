#ifndef MOF_REQ_GET_PETIDLIST_COPY_H
#define MOF_REQ_GET_PETIDLIST_COPY_H

class req_get_petidlist_copy{
public:
	void ~req_get_petidlist_copy();
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_petidlist_copy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif