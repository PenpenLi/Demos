#ifndef MOF_REQ_VERIFY_ROLE_PROP_H
#define MOF_REQ_VERIFY_ROLE_PROP_H

class req_verify_role_prop{
public:
	void req_verify_role_prop(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_verify_role_prop();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif