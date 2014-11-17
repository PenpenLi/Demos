#ifndef MOF_ACK_LOADEQUIP_H
#define MOF_ACK_LOADEQUIP_H

class ack_loadEquip{
public:
	void ack_loadEquip(void);
	void decode(ByteArray &);
	void ~ack_loadEquip();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif