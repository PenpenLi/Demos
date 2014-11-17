#ifndef MOF_ACK_UNEQUIP_SKILL_H
#define MOF_ACK_UNEQUIP_SKILL_H

class ack_unequip_skill{
public:
	void ~ack_unequip_skill();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_unequip_skill(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif