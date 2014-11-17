#ifndef MOF_REQ_ACTIVITY_PET_CASINO_THIEF_H
#define MOF_REQ_ACTIVITY_PET_CASINO_THIEF_H

class req_activity_pet_casino_thief{
public:
	void ~req_activity_pet_casino_thief();
	void decode(ByteArray &);
	void PacketName(void);
	void req_activity_pet_casino_thief(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif