#ifndef MOF_ACK_FINISH_FAMESHALL_H
#define MOF_ACK_FINISH_FAMESHALL_H

class ack_finish_famesHall{
public:
	void ack_finish_famesHall(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ~ack_finish_famesHall();
	void encode(ByteArray &);
}
#endif