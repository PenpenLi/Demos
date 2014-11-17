#ifndef MOF_ACK_ANSWER_QUESTIONCHANGE_H
#define MOF_ACK_ANSWER_QUESTIONCHANGE_H

class ack_answer_questionchange{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_answer_questionchange();
	void ack_answer_questionchange(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif