#ifndef MOF_ACK_QUERYROLE_H
#define MOF_ACK_QUERYROLE_H

class ack_queryrole{
public:
	void ~ack_queryrole();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_queryrole(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif