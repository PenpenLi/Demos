#ifndef MOF_REQ_DELETE_ROLE_H
#define MOF_REQ_DELETE_ROLE_H

class req_delete_role{
public:
	void req_delete_role(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_delete_role();
}
#endif