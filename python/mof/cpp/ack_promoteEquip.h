#ifndef MOF_ACK_PROMOTEEQUIP_H
#define MOF_ACK_PROMOTEEQUIP_H

class ack_promoteEquip{
public:
	void ack_promoteEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_promoteEquip();
}
#endif