#ifndef MOF_ACK_ACTIVITY_PET_CASINO_WAGER_H
#define MOF_ACK_ACTIVITY_PET_CASINO_WAGER_H

class ack_activity_pet_casino_wager{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_activity_pet_casino_wager();
	void ack_activity_pet_casino_wager(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif