#ifndef MOF_ACK_LIST_PET_H
#define MOF_ACK_LIST_PET_H

class ack_list_pet{
public:
	void ack_list_pet(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ~ack_list_pet();
	void encode(ByteArray &);
}
#endif