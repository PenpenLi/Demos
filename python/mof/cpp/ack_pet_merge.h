#ifndef MOF_ACK_PET_MERGE_H
#define MOF_ACK_PET_MERGE_H

class ack_pet_merge{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_pet_merge();
	void ack_pet_merge(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif