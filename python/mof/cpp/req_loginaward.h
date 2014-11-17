#ifndef MOF_REQ_LOGINAWARD_H
#define MOF_REQ_LOGINAWARD_H

class req_loginaward{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_loginaward();
	void req_loginaward(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif