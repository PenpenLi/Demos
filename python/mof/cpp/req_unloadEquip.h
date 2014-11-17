#ifndef MOF_REQ_UNLOADEQUIP_H
#define MOF_REQ_UNLOADEQUIP_H

class req_unloadEquip{
public:
	void ~req_unloadEquip();
	void req_unloadEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif