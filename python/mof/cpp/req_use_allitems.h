#ifndef MOF_REQ_USE_ALLITEMS_H
#define MOF_REQ_USE_ALLITEMS_H

class req_use_allitems{
public:
	void ~req_use_allitems();
	void decode(ByteArray &);
	void req_use_allitems(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif