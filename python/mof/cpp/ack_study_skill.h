#ifndef MOF_ACK_STUDY_SKILL_H
#define MOF_ACK_STUDY_SKILL_H

class ack_study_skill{
public:
	void ack_study_skill(void);
	void ~ack_study_skill();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif