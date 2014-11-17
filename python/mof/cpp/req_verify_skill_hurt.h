#ifndef MOF_REQ_VERIFY_SKILL_HURT_H
#define MOF_REQ_VERIFY_SKILL_HURT_H

class req_verify_skill_hurt{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_verify_skill_hurt(void);
	void ~req_verify_skill_hurt();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif