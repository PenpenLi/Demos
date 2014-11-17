#ifndef MOF_ACK_BEGIN_PRINTCOPY_H
#define MOF_ACK_BEGIN_PRINTCOPY_H

class ack_begin_printcopy{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void ack_begin_printcopy(void);
	void build(ByteArray &);
	void ~ack_begin_printcopy();
}
#endif