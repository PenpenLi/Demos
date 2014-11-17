#ifndef MOF_ACK_LOGIN_EFUN_H
#define MOF_ACK_LOGIN_EFUN_H

class ack_login_efun{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login_efun(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_login_efun();
}
#endif