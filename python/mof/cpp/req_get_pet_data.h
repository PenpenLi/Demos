#ifndef MOF_REQ_GET_PET_DATA_H
#define MOF_REQ_GET_PET_DATA_H

class req_get_pet_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_pet_data(void);
	void ~req_get_pet_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif