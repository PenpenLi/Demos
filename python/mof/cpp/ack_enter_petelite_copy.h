#ifndef MOF_ACK_ENTER_PETELITE_COPY_H
#define MOF_ACK_ENTER_PETELITE_COPY_H

class ack_enter_petelite_copy{
public:
	void ack_enter_petelite_copy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_enter_petelite_copy();
}
#endif