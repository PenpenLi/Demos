#ifndef MOF_ACK_USE_PET_H
#define MOF_ACK_USE_PET_H

class ack_use_pet{
public:
	void decode(ByteArray	&);
	void ~ack_use_pet();
	void ack_use_pet(void);
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif