#ifndef MOF_NOTIFY_ANSWER_OVER_H
#define MOF_NOTIFY_ANSWER_OVER_H

class notify_answer_over{
public:
	void ~notify_answer_over();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_answer_over(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif