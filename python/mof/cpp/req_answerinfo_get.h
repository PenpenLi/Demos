#ifndef MOF_REQ_ANSWERINFO_GET_H
#define MOF_REQ_ANSWERINFO_GET_H

class req_answerinfo_get{
public:
	void ~req_answerinfo_get();
	void decode(ByteArray &);
	void PacketName(void);
	void req_answerinfo_get(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif