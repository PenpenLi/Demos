#ifndef MOF_ACK_ATTACHEQUIP_H
#define MOF_ACK_ATTACHEQUIP_H

class ack_attachEquip{
public:
	void build(ByteArray &);
	void PacketName(void);
	void ack_attachEquip(void);
	void decode(ByteArray &);
	void ~ack_attachEquip();
	void encode(ByteArray &);
}
#endif