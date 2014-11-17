#ifndef MOF_REQ_RECALL_PET_H
#define MOF_REQ_RECALL_PET_H

class req_recall_pet{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_recall_pet();
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_recall_pet(void);
}
#endif