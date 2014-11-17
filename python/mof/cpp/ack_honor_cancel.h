#ifndef MOF_ACK_HONOR_CANCEL_H
#define MOF_ACK_HONOR_CANCEL_H

class ack_honor_cancel{
public:
	void ack_honor_cancel(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_honor_cancel();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif