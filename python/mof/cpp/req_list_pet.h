#ifndef MOF_REQ_LIST_PET_H
#define MOF_REQ_LIST_PET_H

class req_list_pet{
public:
	void req_list_pet(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_list_pet();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif