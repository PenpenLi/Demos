#ifndef MOF_ACK_PASS_MYSTICALCOPY_H
#define MOF_ACK_PASS_MYSTICALCOPY_H

class ack_pass_mysticalcopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_pass_mysticalcopy();
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_pass_mysticalcopy(void);
}
#endif