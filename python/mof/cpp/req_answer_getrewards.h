#ifndef MOF_REQ_ANSWER_GETREWARDS_H
#define MOF_REQ_ANSWER_GETREWARDS_H

class req_answer_getrewards{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_answer_getrewards();
	void req_answer_getrewards(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif