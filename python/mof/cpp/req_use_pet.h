#ifndef MOF_REQ_USE_PET_H
#define MOF_REQ_USE_PET_H

class req_use_pet{
public:
	void req_use_pet(void);
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_use_pet();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif