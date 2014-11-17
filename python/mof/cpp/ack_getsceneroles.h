#ifndef MOF_ACK_GETSCENEROLES_H
#define MOF_ACK_GETSCENEROLES_H

class ack_getsceneroles{
public:
	void ~ack_getsceneroles();
	void PacketName(void);
	void ack_getsceneroles(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif