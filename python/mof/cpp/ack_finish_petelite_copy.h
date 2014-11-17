#ifndef MOF_ACK_FINISH_PETELITE_COPY_H
#define MOF_ACK_FINISH_PETELITE_COPY_H

class ack_finish_petelite_copy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_finish_petelite_copy();
	void build(ByteArray &);
	void ack_finish_petelite_copy(void);
}
#endif