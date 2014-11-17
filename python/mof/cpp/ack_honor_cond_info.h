#ifndef MOF_ACK_HONOR_COND_INFO_H
#define MOF_ACK_HONOR_COND_INFO_H

class ack_honor_cond_info{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~ack_honor_cond_info();
	void encode(ByteArray	&);
	void ack_honor_cond_info(void);
	void build(ByteArray &);
}
#endif