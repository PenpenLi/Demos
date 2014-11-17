#ifndef MOF_REQ_ACTIVITY_PET_CASINO_CURRENT_HISTORY_H
#define MOF_REQ_ACTIVITY_PET_CASINO_CURRENT_HISTORY_H

class req_activity_pet_casino_current_history{
public:
	void req_activity_pet_casino_current_history(void);
	void ~req_activity_pet_casino_current_history();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif