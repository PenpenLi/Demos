#ifndef MOF_ACK_PET_REFINE_GROWTH_H
#define MOF_ACK_PET_REFINE_GROWTH_H

class ack_pet_refine_growth{
public:
	void ack_pet_refine_growth(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_pet_refine_growth();
}
#endif