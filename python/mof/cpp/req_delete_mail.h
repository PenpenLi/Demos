#ifndef MOF_REQ_DELETE_MAIL_H
#define MOF_REQ_DELETE_MAIL_H

class req_delete_mail{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_delete_mail();
	void req_delete_mail(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif