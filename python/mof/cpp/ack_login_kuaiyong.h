#ifndef MOF_ACK_LOGIN_KUAIYONG_H
#define MOF_ACK_LOGIN_KUAIYONG_H

class ack_login_kuaiyong{
public:
	void ack_login_kuaiyong(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_login_kuaiyong();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif