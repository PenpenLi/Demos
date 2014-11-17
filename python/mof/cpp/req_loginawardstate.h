#ifndef MOF_REQ_LOGINAWARDSTATE_H
#define MOF_REQ_LOGINAWARDSTATE_H

class req_loginawardstate{
public:
	void decode(ByteArray	&);
	void req_loginawardstate(void);
	void ~req_loginawardstate();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif