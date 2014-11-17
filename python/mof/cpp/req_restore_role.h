#ifndef MOF_REQ_RESTORE_ROLE_H
#define MOF_REQ_RESTORE_ROLE_H

class req_restore_role{
public:
	void req_restore_role(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_restore_role();
}
#endif