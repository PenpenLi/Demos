#ifndef MOF_ACK_LOGIN_KUAIYONG2_H
#define MOF_ACK_LOGIN_KUAIYONG2_H

class ack_login_kuaiyong2{
public:
	void decode(ByteArray	&);
	void ack_login_kuaiyong2(void);
	void PacketName(void);
	void encode(ByteArray	&);
	void ~ack_login_kuaiyong2();
	void build(ByteArray &);
}
#endif