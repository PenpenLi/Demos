#ifndef MOF_REQ_ILLUSTRATIONS_REWARD_H
#define MOF_REQ_ILLUSTRATIONS_REWARD_H

class req_illustrations_reward{
public:
	void req_illustrations_reward(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_illustrations_reward();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif