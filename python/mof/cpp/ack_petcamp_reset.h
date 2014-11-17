#ifndef MOF_ACK_PETCAMP_RESET_H
#define MOF_ACK_PETCAMP_RESET_H

class ack_petcamp_reset{
public:
	void ~ack_petcamp_reset();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_petcamp_reset(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif