#ifndef MOF_ACK_DELETE_MAIL_H
#define MOF_ACK_DELETE_MAIL_H

class ack_delete_mail{
public:
	void ack_delete_mail(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_delete_mail();
}
#endif