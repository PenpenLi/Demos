#ifndef MOF_ACK_USEITEM_H
#define MOF_ACK_USEITEM_H

class ack_useitem{
public:
	void decode(ByteArray	&);
	void build(ByteArray &);
	void PacketName(void);
	void ~ack_useitem();
	void encode(ByteArray	&);
	void ack_useitem(void);
}
#endif