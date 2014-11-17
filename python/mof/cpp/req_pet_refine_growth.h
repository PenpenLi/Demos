#ifndef MOF_REQ_PET_REFINE_GROWTH_H
#define MOF_REQ_PET_REFINE_GROWTH_H

class req_pet_refine_growth{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_pet_refine_growth();
	void req_pet_refine_growth(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif