#ifndef MOF_REQ_BEGIN_PET_DUNGE_H
#define MOF_REQ_BEGIN_PET_DUNGE_H

class req_begin_pet_dunge{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void req_begin_pet_dunge(void);
	void ~req_begin_pet_dunge();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif