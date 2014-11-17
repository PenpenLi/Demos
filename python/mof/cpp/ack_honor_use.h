#ifndef MOF_ACK_HONOR_USE_H
#define MOF_ACK_HONOR_USE_H

class ack_honor_use{
public:
	void ack_honor_use(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_honor_use();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif