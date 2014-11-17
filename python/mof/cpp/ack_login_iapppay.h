#ifndef MOF_ACK_LOGIN_IAPPPAY_H
#define MOF_ACK_LOGIN_IAPPPAY_H

class ack_login_iapppay{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login_iapppay(void);
	void ~ack_login_iapppay();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif