#ifndef MOF_ACK_ASSIST_PET_LIST_H
#define MOF_ACK_ASSIST_PET_LIST_H

class ack_assist_pet_list{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ack_assist_pet_list(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
	void ~ack_assist_pet_list();
}
#endif