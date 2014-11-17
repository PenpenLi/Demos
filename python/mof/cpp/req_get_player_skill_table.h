#ifndef MOF_REQ_GET_PLAYER_SKILL_TABLE_H
#define MOF_REQ_GET_PLAYER_SKILL_TABLE_H

class req_get_player_skill_table{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_player_skill_table(void);
	void ~req_get_player_skill_table();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif