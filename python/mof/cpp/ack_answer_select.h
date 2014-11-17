#ifndef MOF_ACK_ANSWER_SELECT_H
#define MOF_ACK_ANSWER_SELECT_H

class ack_answer_select{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_answer_select();
	void ack_answer_select(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif