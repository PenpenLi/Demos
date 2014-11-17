#ifndef MOF_ACK_LOGIN_XINYOU_H
#define MOF_ACK_LOGIN_XINYOU_H

class ack_login_xinyou{
public:
	void ack_login_xinyou(void);
	void ~ack_login_xinyou();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif