#ifndef MOF_ACK_FINISHQUEST_H
#define MOF_ACK_FINISHQUEST_H

class ack_finishQuest{
public:
	void ack_finishQuest(void);
	void ~ack_finishQuest();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif