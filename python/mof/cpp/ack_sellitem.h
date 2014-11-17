#ifndef MOF_ACK_SELLITEM_H
#define MOF_ACK_SELLITEM_H

class ack_sellitem{
public:
	void ack_sellitem(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
	void ~ack_sellitem();
}
#endif