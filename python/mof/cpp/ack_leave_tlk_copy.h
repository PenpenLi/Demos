#ifndef MOF_ACK_LEAVE_TLK_COPY_H
#define MOF_ACK_LEAVE_TLK_COPY_H

class ack_leave_tlk_copy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_leave_tlk_copy(void);
	void ~ack_leave_tlk_copy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif