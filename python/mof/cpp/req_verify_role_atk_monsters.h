#ifndef MOF_REQ_VERIFY_ROLE_ATK_MONSTERS_H
#define MOF_REQ_VERIFY_ROLE_ATK_MONSTERS_H

class req_verify_role_atk_monsters{
public:
	void ~req_verify_role_atk_monsters();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void req_verify_role_atk_monsters(void);
	void encode(ByteArray &);
}
#endif