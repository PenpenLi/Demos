#ifndef MOF_REQ_GET_MAIL_H
#define MOF_REQ_GET_MAIL_H

class req_get_mail{
public:
	void req_get_mail(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_get_mail();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif