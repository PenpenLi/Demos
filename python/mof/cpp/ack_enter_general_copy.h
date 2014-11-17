#ifndef MOF_ACK_ENTER_GENERAL_COPY_H
#define MOF_ACK_ENTER_GENERAL_COPY_H

class ack_enter_general_copy{
public:
	void ~ack_enter_general_copy();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_enter_general_copy(void);
}
#endif