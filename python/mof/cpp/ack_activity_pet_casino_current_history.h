#ifndef MOF_ACK_ACTIVITY_PET_CASINO_CURRENT_HISTORY_H
#define MOF_ACK_ACTIVITY_PET_CASINO_CURRENT_HISTORY_H

class ack_activity_pet_casino_current_history{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_activity_pet_casino_current_history(void);
	void ~ack_activity_pet_casino_current_history();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif