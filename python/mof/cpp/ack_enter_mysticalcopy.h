#ifndef MOF_ACK_ENTER_MYSTICALCOPY_H
#define MOF_ACK_ENTER_MYSTICALCOPY_H

class ack_enter_mysticalcopy{
public:
	void ack_enter_mysticalcopy(void);
	void PacketName(void);
	void ~ack_enter_mysticalcopy();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif