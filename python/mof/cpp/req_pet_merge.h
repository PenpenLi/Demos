#ifndef MOF_REQ_PET_MERGE_H
#define MOF_REQ_PET_MERGE_H

class req_pet_merge{
public:
	void ~req_pet_merge();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_pet_merge(void);
}
#endif