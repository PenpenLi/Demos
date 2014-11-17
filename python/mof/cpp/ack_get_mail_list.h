#ifndef MOF_ACK_GET_MAIL_LIST_H
#define MOF_ACK_GET_MAIL_LIST_H

class ack_get_mail_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_mail_list();
	void ack_get_mail_list(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif