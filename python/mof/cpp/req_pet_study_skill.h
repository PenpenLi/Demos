#ifndef MOF_REQ_PET_STUDY_SKILL_H
#define MOF_REQ_PET_STUDY_SKILL_H

class req_pet_study_skill{
public:
	void req_pet_study_skill(void);
	void PacketName(void);
	void ~req_pet_study_skill();
	void encode(ByteArray	&);
	void decode(ByteArray	&);
	void build(ByteArray &);
}
#endif