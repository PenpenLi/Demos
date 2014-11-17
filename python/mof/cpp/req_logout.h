#ifndef MOF_REQ_LOGOUT_H
#define MOF_REQ_LOGOUT_H

class req_logout{
public:
	void ~req_logout();
	void decode(ByteArray &);
	void PacketName(void);
	void req_logout(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif