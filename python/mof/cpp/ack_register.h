#ifndef MOF_ACK_REGISTER_H
#define MOF_ACK_REGISTER_H

class ack_register{
public:
	void ~ack_register();
	void PacketName(void);
	void ack_register(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif