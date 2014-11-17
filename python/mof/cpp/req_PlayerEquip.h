#ifndef MOF_REQ_PLAYEREQUIP_H
#define MOF_REQ_PLAYEREQUIP_H

class req_PlayerEquip{
public:
	void decode(ByteArray &);
	void req_PlayerEquip(void);
	void PacketName(void);
	void ~req_PlayerEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif