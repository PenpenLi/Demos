#ifndef MOF_ACK_TAKEOFF_FASHION_H
#define MOF_ACK_TAKEOFF_FASHION_H

class ack_takeoff_fashion{
public:
	void ~ack_takeoff_fashion();
	void decode(ByteArray	&);
	void PacketName(void);
	void ack_takeoff_fashion(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif