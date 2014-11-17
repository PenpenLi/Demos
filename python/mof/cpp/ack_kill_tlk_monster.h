#ifndef MOF_ACK_KILL_TLK_MONSTER_H
#define MOF_ACK_KILL_TLK_MONSTER_H

class ack_kill_tlk_monster{
public:
	void ~ack_kill_tlk_monster();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_kill_tlk_monster(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif