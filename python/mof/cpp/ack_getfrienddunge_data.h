#ifndef MOF_ACK_GETFRIENDDUNGE_DATA_H
#define MOF_ACK_GETFRIENDDUNGE_DATA_H

class ack_getfrienddunge_data{
public:
	void ~ack_getfrienddunge_data();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_getfrienddunge_data(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif