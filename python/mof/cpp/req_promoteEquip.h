#ifndef MOF_REQ_PROMOTEEQUIP_H
#define MOF_REQ_PROMOTEEQUIP_H

class req_promoteEquip{
public:
	void req_promoteEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_promoteEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif