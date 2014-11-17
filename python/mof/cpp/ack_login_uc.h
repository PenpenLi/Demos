#ifndef MOF_ACK_LOGIN_UC_H
#define MOF_ACK_LOGIN_UC_H

class ack_login_uc{
public:
	void ack_login_uc(void);
	void ~ack_login_uc();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif