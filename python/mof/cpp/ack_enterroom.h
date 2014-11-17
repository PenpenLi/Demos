#ifndef MOF_ACK_ENTERROOM_H
#define MOF_ACK_ENTERROOM_H

class ack_enterroom{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_enterroom();
	void ack_enterroom(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif