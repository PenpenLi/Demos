#ifndef MOF_ACK_LEAVE_MYSTICALCOPY_H
#define MOF_ACK_LEAVE_MYSTICALCOPY_H

class ack_leave_mysticalcopy{
public:
	void ack_leave_mysticalcopy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_leave_mysticalcopy();
}
#endif