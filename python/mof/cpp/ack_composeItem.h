#ifndef MOF_ACK_COMPOSEITEM_H
#define MOF_ACK_COMPOSEITEM_H

class ack_composeItem{
public:
	void ~ack_composeItem();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_composeItem(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif