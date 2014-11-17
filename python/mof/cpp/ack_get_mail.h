#ifndef MOF_ACK_GET_MAIL_H
#define MOF_ACK_GET_MAIL_H

class ack_get_mail{
public:
	void ~ack_get_mail();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_get_mail(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif