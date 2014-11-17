#ifndef MOF_ACK_DUNGCOPY_RESET_H
#define MOF_ACK_DUNGCOPY_RESET_H

class ack_dungcopy_reset{
public:
	void ack_dungcopy_reset(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_dungcopy_reset();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif