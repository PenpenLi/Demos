#ifndef MOF_REQ_SET_ASSIST_PET_H
#define MOF_REQ_SET_ASSIST_PET_H

class req_set_assist_pet{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_set_assist_pet(void);
	void ~req_set_assist_pet();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif