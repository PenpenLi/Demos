#ifndef MOF_REQ_ASSIST_PET_LIST_H
#define MOF_REQ_ASSIST_PET_LIST_H

class req_assist_pet_list{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_assist_pet_list();
	void encode(ByteArray	&);
	void build(ByteArray &);
	void req_assist_pet_list(void);
}
#endif