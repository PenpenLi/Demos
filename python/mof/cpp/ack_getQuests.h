#ifndef MOF_ACK_GETQUESTS_H
#define MOF_ACK_GETQUESTS_H

class ack_getQuests{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_getQuests();
	void ack_getQuests(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif