#ifndef MOF_ACK_GIVEUPQUEST_H
#define MOF_ACK_GIVEUPQUEST_H

class ack_giveupQuest{
public:
	void decode(ByteArray &);
	void ack_giveupQuest(void);
	void PacketName(void);
	void ~ack_giveupQuest();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif