#ifndef MOF_ACK_PRE_REDIRECT_NAME_H
#define MOF_ACK_PRE_REDIRECT_NAME_H

class ack_pre_redirect_name{
public:
	void ack_pre_redirect_name(void);
	void ~ack_pre_redirect_name();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif