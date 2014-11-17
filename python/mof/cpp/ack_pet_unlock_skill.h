#ifndef MOF_ACK_PET_UNLOCK_SKILL_H
#define MOF_ACK_PET_UNLOCK_SKILL_H

class ack_pet_unlock_skill{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_pet_unlock_skill(void);
	void ~ack_pet_unlock_skill();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif