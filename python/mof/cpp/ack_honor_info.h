#ifndef MOF_ACK_HONOR_INFO_H
#define MOF_ACK_HONOR_INFO_H

class ack_honor_info{
public:
	void ~ack_honor_info();
	void ack_honor_info(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif