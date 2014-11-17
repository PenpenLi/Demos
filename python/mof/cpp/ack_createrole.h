#ifndef MOF_ACK_CREATEROLE_H
#define MOF_ACK_CREATEROLE_H

class ack_createrole{
public:
	void ~ack_createrole();
	void ack_createrole(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif