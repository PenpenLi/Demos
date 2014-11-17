#ifndef MOF_ACK_DEATTACHEQUIP_H
#define MOF_ACK_DEATTACHEQUIP_H

class ack_deattachEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_deattachEquip(void);
	void ~ack_deattachEquip();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif