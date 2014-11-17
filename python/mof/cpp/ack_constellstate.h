#ifndef MOF_ACK_CONSTELLSTATE_H
#define MOF_ACK_CONSTELLSTATE_H

class ack_constellstate{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_constellstate(void);
	void ~ack_constellstate();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif