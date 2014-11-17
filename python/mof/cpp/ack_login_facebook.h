#ifndef MOF_ACK_LOGIN_FACEBOOK_H
#define MOF_ACK_LOGIN_FACEBOOK_H

class ack_login_facebook{
public:
	void decode(ByteArray &);
	void ~ack_login_facebook();
	void PacketName(void);
	void ack_login_facebook(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif