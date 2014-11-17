#ifndef MOF_ACK_LOGIN_I4_H
#define MOF_ACK_LOGIN_I4_H

class ack_login_i4{
public:
	void ~ack_login_i4();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login_i4(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif