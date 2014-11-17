#ifndef MOF_ACK_LOGIN_PPS_H
#define MOF_ACK_LOGIN_PPS_H

class ack_login_pps{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_login_pps();
	void ack_login_pps(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif