#ifndef MOF_NOTIFY_NEW_APPLICANT_H
#define MOF_NOTIFY_NEW_APPLICANT_H

class notify_new_applicant{
public:
	void decode(ByteArray &);
	void notify_new_applicant(void);
	void PacketName(void);
	void ~notify_new_applicant();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif