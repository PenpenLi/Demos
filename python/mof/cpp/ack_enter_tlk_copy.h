#ifndef MOF_ACK_ENTER_TLK_COPY_H
#define MOF_ACK_ENTER_TLK_COPY_H

class ack_enter_tlk_copy{
public:
	void ~ack_enter_tlk_copy();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_enter_tlk_copy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif