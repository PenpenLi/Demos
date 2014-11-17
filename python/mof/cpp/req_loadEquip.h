#ifndef MOF_REQ_LOADEQUIP_H
#define MOF_REQ_LOADEQUIP_H

class req_loadEquip{
public:
	void req_loadEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_loadEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif