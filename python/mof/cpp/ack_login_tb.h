#ifndef MOF_ACK_LOGIN_TB_H
#define MOF_ACK_LOGIN_TB_H

class ack_login_tb{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_login_tb();
	void ack_login_tb(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif