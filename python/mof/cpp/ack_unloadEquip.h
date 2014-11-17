#ifndef MOF_ACK_UNLOADEQUIP_H
#define MOF_ACK_UNLOADEQUIP_H

class ack_unloadEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_unloadEquip(void);
	void ~ack_unloadEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif