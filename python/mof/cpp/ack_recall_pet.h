#ifndef MOF_ACK_RECALL_PET_H
#define MOF_ACK_RECALL_PET_H

class ack_recall_pet{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_recall_pet();
	void ack_recall_pet(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif