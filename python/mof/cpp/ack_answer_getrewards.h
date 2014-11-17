#ifndef MOF_ACK_ANSWER_GETREWARDS_H
#define MOF_ACK_ANSWER_GETREWARDS_H

class ack_answer_getrewards{
public:
	void ack_answer_getrewards(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_answer_getrewards();
}
#endif