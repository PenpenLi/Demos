#ifndef MOF_ACK_LOGINAWARD_H
#define MOF_ACK_LOGINAWARD_H

class ack_loginaward{
public:
	void ~ack_loginaward();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_loginaward(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif