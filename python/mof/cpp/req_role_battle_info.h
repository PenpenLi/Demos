#ifndef MOF_REQ_ROLE_BATTLE_INFO_H
#define MOF_REQ_ROLE_BATTLE_INFO_H

class req_role_battle_info{
public:
	void req_role_battle_info(void);
	void decode(ByteArray &);
	void ~req_role_battle_info();
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif