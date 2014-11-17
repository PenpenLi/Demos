#ifndef MOF_ACK_LOGINAWARDSTATE_H
#define MOF_ACK_LOGINAWARDSTATE_H

class ack_loginawardstate{
public:
	void decode(ByteArray	&);
	void ~ack_loginawardstate();
	void PacketName(void);
	void ack_loginawardstate(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif