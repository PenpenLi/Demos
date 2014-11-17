#ifndef MOF_NOTIFY_NEW_MAIL_H
#define MOF_NOTIFY_NEW_MAIL_H

class notify_new_mail{
public:
	void ~notify_new_mail();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_new_mail(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif