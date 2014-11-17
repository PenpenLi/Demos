#ifndef MOF_ACK_FUSIONEQUIP_H
#define MOF_ACK_FUSIONEQUIP_H

class ack_fusionEquip{
public:
	void ack_fusionEquip(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_fusionEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif