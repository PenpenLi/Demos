#ifndef MOF_REQ_LOGIN_91_H
#define MOF_REQ_LOGIN_91_H

class req_login_91{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_login_91(void);
	void build(ByteArray	&);
	void ~req_login_91();
	void encode(ByteArray &);
}
#endif