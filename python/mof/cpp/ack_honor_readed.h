#ifndef MOF_ACK_HONOR_READED_H
#define MOF_ACK_HONOR_READED_H

class ack_honor_readed{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_honor_readed();
	void encode(ByteArray &);
	void build(ByteArray &);
	void ack_honor_readed(void);
}
#endif