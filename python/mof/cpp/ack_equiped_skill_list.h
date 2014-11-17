#ifndef MOF_ACK_EQUIPED_SKILL_LIST_H
#define MOF_ACK_EQUIPED_SKILL_LIST_H

class ack_equiped_skill_list{
public:
	void ~ack_equiped_skill_list();
	void ack_equiped_skill_list(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif