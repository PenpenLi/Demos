#ifndef MOF_NOTIFY_REJECT_APPLY_FOR_APPLICANT_H
#define MOF_NOTIFY_REJECT_APPLY_FOR_APPLICANT_H

class notify_reject_apply_for_applicant{
public:
	void notify_reject_apply_for_applicant(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_reject_apply_for_applicant();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif