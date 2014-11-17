#ifndef MOF_ACK_CONSTELLUPG_H
#define MOF_ACK_CONSTELLUPG_H

class ack_constellupg{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_constellupg();
	void ack_constellupg(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif