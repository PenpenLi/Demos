#ifndef MOF_ACK_REDIRECT_NAME_H
#define MOF_ACK_REDIRECT_NAME_H

class ack_redirect_name{
public:
	void ack_redirect_name(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_redirect_name();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif