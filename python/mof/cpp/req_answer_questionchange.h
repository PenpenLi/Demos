#ifndef MOF_REQ_ANSWER_QUESTIONCHANGE_H
#define MOF_REQ_ANSWER_QUESTIONCHANGE_H

class req_answer_questionchange{
public:
	void req_answer_questionchange(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_answer_questionchange();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif