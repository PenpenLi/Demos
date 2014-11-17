#ifndef MOF_ACK_LOGIN_GOOGLE_H
#define MOF_ACK_LOGIN_GOOGLE_H

class ack_login_google{
public:
	void ~ack_login_google();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login_google(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif