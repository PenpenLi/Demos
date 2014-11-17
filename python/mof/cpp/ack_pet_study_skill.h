#ifndef MOF_ACK_PET_STUDY_SKILL_H
#define MOF_ACK_PET_STUDY_SKILL_H

class ack_pet_study_skill{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~ack_pet_study_skill();
	void ack_pet_study_skill(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif