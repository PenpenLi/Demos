#ifndef MOF_REQ_STUDY_SKILL_H
#define MOF_REQ_STUDY_SKILL_H

class req_study_skill{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_study_skill(void);
	void ~req_study_skill();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif