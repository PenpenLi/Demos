#ifndef MOF_REQ_ANSWER_SELECT_H
#define MOF_REQ_ANSWER_SELECT_H

class req_answer_select{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_answer_select();
	void req_answer_select(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif