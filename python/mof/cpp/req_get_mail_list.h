#ifndef MOF_REQ_GET_MAIL_LIST_H
#define MOF_REQ_GET_MAIL_LIST_H

class req_get_mail_list{
public:
	void ~req_get_mail_list();
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_mail_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif