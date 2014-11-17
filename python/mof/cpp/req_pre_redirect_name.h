#ifndef MOF_REQ_PRE_REDIRECT_NAME_H
#define MOF_REQ_PRE_REDIRECT_NAME_H

class req_pre_redirect_name{
public:
	void ~req_pre_redirect_name();
	void decode(ByteArray &);
	void PacketName(void);
	void req_pre_redirect_name(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif