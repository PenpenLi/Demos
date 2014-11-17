#ifndef MOF_ACK_LOGIN_HAIMA_H
#define MOF_ACK_LOGIN_HAIMA_H

class ack_login_haima{
public:
	void ack_login_haima(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_login_haima();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif