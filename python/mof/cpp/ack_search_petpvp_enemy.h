#ifndef MOF_ACK_SEARCH_PETPVP_ENEMY_H
#define MOF_ACK_SEARCH_PETPVP_ENEMY_H

class ack_search_petpvp_enemy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_search_petpvp_enemy();
	void ack_search_petpvp_enemy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif