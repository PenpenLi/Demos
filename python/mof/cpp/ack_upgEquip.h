#ifndef MOF_ACK_UPGEQUIP_H
#define MOF_ACK_UPGEQUIP_H

class ack_upgEquip{
public:
	void ack_upgEquip(void);
	void ~ack_upgEquip();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif