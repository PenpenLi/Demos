#ifndef MOF_REQ_ABSORB_PET_H
#define MOF_REQ_ABSORB_PET_H

class req_absorb_pet{
public:
	void decode(ByteArray &);
	void req_absorb_pet(void);
	void PacketName(void);
	void ~req_absorb_pet();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif