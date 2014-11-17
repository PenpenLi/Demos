#ifndef MOF_ACK_ACTIVITY_PET_CASINO_THIEF_H
#define MOF_ACK_ACTIVITY_PET_CASINO_THIEF_H

class ack_activity_pet_casino_thief{
public:
	void decode(ByteArray &);
	void ack_activity_pet_casino_thief(void);
	void PacketName(void);
	void ~ack_activity_pet_casino_thief();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif