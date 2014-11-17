#ifndef MOF_ACK_ACTIVITY_PET_CASINO_STATUS_H
#define MOF_ACK_ACTIVITY_PET_CASINO_STATUS_H

class ack_activity_pet_casino_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_activity_pet_casino_status();
	void ack_activity_pet_casino_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif