#ifndef MOF_REQ_REDIRECT_NAME_H
#define MOF_REQ_REDIRECT_NAME_H

class req_redirect_name{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_redirect_name();
	void req_redirect_name(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif