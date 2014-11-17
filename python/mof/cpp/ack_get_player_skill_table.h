#ifndef MOF_ACK_GET_PLAYER_SKILL_TABLE_H
#define MOF_ACK_GET_PLAYER_SKILL_TABLE_H

class ack_get_player_skill_table{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_player_skill_table();
	void ack_get_player_skill_table(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif