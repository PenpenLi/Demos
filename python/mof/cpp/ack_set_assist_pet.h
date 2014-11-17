#ifndef MOF_ACK_SET_ASSIST_PET_H
#define MOF_ACK_SET_ASSIST_PET_H

class ack_set_assist_pet{
public:
	void ~ack_set_assist_pet();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_set_assist_pet(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif