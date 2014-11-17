#ifndef MOF_ACK_FRESHPROP_BYDAY_H
#define MOF_ACK_FRESHPROP_BYDAY_H

class ack_freshprop_byday{
public:
	void ~ack_freshprop_byday();
	void decode(ByteArray	&);
	void PacketName(void);
	void ack_freshprop_byday(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif