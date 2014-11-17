#ifndef MOF_REQ_PET_UNLOCK_SKILL_H
#define MOF_REQ_PET_UNLOCK_SKILL_H

class req_pet_unlock_skill{
public:
	void PacketName(void);
	void decode(ByteArray &);
	void ~req_pet_unlock_skill();
	void req_pet_unlock_skill(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif