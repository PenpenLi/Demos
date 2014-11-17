#ifndef MOF_ACK_PLAYEREQUIP_H
#define MOF_ACK_PLAYEREQUIP_H

class ack_PlayerEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_PlayerEquip();
	void build(ByteArray &);
	void ack_PlayerEquip(void);
}
#endif