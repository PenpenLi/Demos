#ifndef MOF_ACK_LOGIN_91_H
#define MOF_ACK_LOGIN_91_H

class ack_login_91{
public:
	void ~ack_login_91();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login_91(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif