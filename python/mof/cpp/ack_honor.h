#ifndef MOF_ACK_HONOR_H
#define MOF_ACK_HONOR_H

class ack_honor{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_honor(void);
	void ~ack_honor();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif