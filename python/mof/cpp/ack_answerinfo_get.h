#ifndef MOF_ACK_ANSWERINFO_GET_H
#define MOF_ACK_ANSWERINFO_GET_H

class ack_answerinfo_get{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_answerinfo_get(void);
	void ~ack_answerinfo_get();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif