#ifndef MOF_REQ_UNEQUIP_SKILL_H
#define MOF_REQ_UNEQUIP_SKILL_H

class req_unequip_skill{
public:
	void ~req_unequip_skill();
	void decode(ByteArray &);
	void PacketName(void);
	void req_unequip_skill(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif