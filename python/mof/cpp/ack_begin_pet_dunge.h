#ifndef MOF_ACK_BEGIN_PET_DUNGE_H
#define MOF_ACK_BEGIN_PET_DUNGE_H

class ack_begin_pet_dunge{
public:
	void decode(ByteArray	&);
	void ack_begin_pet_dunge(void);
	void PacketName(void);
	void ~ack_begin_pet_dunge();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif