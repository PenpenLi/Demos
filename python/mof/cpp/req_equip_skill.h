#ifndef MOF_REQ_EQUIP_SKILL_H
#define MOF_REQ_EQUIP_SKILL_H

class req_equip_skill{
public:
	void req_equip_skill(void);
	void ~req_equip_skill();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif