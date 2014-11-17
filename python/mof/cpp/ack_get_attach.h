#ifndef MOF_ACK_GET_ATTACH_H
#define MOF_ACK_GET_ATTACH_H

class ack_get_attach{
public:
	void ack_get_attach(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_attach();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif