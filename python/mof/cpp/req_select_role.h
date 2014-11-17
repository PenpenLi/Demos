#ifndef MOF_REQ_SELECT_ROLE_H
#define MOF_REQ_SELECT_ROLE_H

class req_select_role{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_select_role();
	void req_select_role(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif