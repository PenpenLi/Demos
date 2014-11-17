#ifndef MOF_REQ_LOGIN_H
#define MOF_REQ_LOGIN_H

class req_login{
public:
	void decode(ByteArray &);
	void ~req_login();
	void PacketName(void);
	void req_login(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif