#ifndef MOF_REQ_ACTIVITY_PET_CASINO_WAGER_H
#define MOF_REQ_ACTIVITY_PET_CASINO_WAGER_H

class req_activity_pet_casino_wager{
public:
	void req_activity_pet_casino_wager(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_activity_pet_casino_wager();
}
#endif