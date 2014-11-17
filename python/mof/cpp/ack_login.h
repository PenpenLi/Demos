#ifndef MOF_ACK_LOGIN_H
#define MOF_ACK_LOGIN_H

class ack_login{
public:
	void ~ack_login();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_login(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif