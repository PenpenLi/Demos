#ifndef MOF_REQ_EQUIPED_SKILL_LIST_H
#define MOF_REQ_EQUIPED_SKILL_LIST_H

class req_equiped_skill_list{
public:
	void req_equiped_skill_list(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_equiped_skill_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif