#ifndef MOF_ACK_ABSORB_PET_H
#define MOF_ACK_ABSORB_PET_H

class ack_absorb_pet{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_absorb_pet(void);
	void ~ack_absorb_pet();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif