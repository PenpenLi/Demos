#ifndef MOF_REQ_ANSWER_TOTALREWARDS_H
#define MOF_REQ_ANSWER_TOTALREWARDS_H

class req_answer_totalrewards{
public:
	void req_answer_totalrewards(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_answer_totalrewards();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif