#ifndef MOF_ACK_RECVQUEST_H
#define MOF_ACK_RECVQUEST_H

class ack_recvQuest{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_recvQuest();
	void ack_recvQuest(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif