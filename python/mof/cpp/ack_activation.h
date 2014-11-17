#ifndef MOF_ACK_ACTIVATION_H
#define MOF_ACK_ACTIVATION_H

class ack_activation{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_activation();
	void ack_activation(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif