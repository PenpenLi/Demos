#ifndef MOF_ACK_ILLUSTRATIONS_REWARD_H
#define MOF_ACK_ILLUSTRATIONS_REWARD_H

class ack_illustrations_reward{
public:
	void ack_illustrations_reward(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_illustrations_reward();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif