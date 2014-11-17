#ifndef MOF_REQ_ACTIVITY_PET_CASINO_STATUS_H
#define MOF_REQ_ACTIVITY_PET_CASINO_STATUS_H

class req_activity_pet_casino_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_activity_pet_casino_status();
	void req_activity_pet_casino_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif