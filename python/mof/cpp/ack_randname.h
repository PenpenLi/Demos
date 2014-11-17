#ifndef MOF_ACK_RANDNAME_H
#define MOF_ACK_RANDNAME_H

class ack_randname{
public:
	void ack_randname(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void ~ack_randname();
	void encode(ByteArray &);
}
#endif