#ifndef MOF_REQ_KILL_TLK_MONSTER_H
#define MOF_REQ_KILL_TLK_MONSTER_H

class req_kill_tlk_monster{
public:
	void ~req_kill_tlk_monster();
	void req_kill_tlk_monster(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif