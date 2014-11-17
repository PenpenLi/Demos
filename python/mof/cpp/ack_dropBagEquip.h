#ifndef MOF_ACK_DROPBAGEQUIP_H
#define MOF_ACK_DROPBAGEQUIP_H

class ack_dropBagEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_dropBagEquip();
	void ack_dropBagEquip(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif