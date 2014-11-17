#ifndef MOF_REQ_SKILL_HURT_H
#define MOF_REQ_SKILL_HURT_H

class req_skill_hurt{
public:
	void req_skill_hurt(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_skill_hurt();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif