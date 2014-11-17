#ifndef MOF_ACK_PRINTCOPY_RESET_H
#define MOF_ACK_PRINTCOPY_RESET_H

class ack_printcopy_reset{
public:
	void decode(ByteArray	&);
	void ~ack_printcopy_reset();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
	void ack_printcopy_reset(void);
}
#endif