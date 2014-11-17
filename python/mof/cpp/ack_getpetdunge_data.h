#ifndef MOF_ACK_GETPETDUNGE_DATA_H
#define MOF_ACK_GETPETDUNGE_DATA_H

class ack_getpetdunge_data{
public:
	void ~ack_getpetdunge_data();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ack_getpetdunge_data(void);
	void encode(ByteArray &);
}
#endif