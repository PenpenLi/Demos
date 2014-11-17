#ifndef MOF_ACK_FINISH_PET_DUNGE_H
#define MOF_ACK_FINISH_PET_DUNGE_H

class ack_finish_pet_dunge{
public:
	void ~ack_finish_pet_dunge();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_finish_pet_dunge(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif