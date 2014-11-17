#ifndef MOF_REQ_FINISH_PET_DUNGE_H
#define MOF_REQ_FINISH_PET_DUNGE_H

class req_finish_pet_dunge{
public:
	void ~req_finish_pet_dunge();
	void decode(ByteArray &);
	void PacketName(void);
	void req_finish_pet_dunge(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif