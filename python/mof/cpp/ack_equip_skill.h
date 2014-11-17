#ifndef MOF_ACK_EQUIP_SKILL_H
#define MOF_ACK_EQUIP_SKILL_H

class ack_equip_skill{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_equip_skill(void);
	void ~ack_equip_skill();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif