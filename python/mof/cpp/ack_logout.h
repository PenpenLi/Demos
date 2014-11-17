#ifndef MOF_ACK_LOGOUT_H
#define MOF_ACK_LOGOUT_H

class ack_logout{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_logout();
	void build(ByteArray &);
	void ack_logout(void);
}
#endif