#ifndef MOF_ACK_PING_H
#define MOF_ACK_PING_H

class ack_ping{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_ping(void);
	void ~ack_ping();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif