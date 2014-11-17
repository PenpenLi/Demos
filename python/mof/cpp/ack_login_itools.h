#ifndef MOF_ACK_LOGIN_ITOOLS_H
#define MOF_ACK_LOGIN_ITOOLS_H

class ack_login_itools{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_login_itools();
	void build(ByteArray &);
	void ack_login_itools(void);
}
#endif