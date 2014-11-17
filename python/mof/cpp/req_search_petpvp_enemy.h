#ifndef MOF_REQ_SEARCH_PETPVP_ENEMY_H
#define MOF_REQ_SEARCH_PETPVP_ENEMY_H

class req_search_petpvp_enemy{
public:
	void req_search_petpvp_enemy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_search_petpvp_enemy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif