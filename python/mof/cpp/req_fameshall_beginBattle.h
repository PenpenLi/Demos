#ifndef MOF_REQ_FAMESHALL_BEGINBATTLE_H
#define MOF_REQ_FAMESHALL_BEGINBATTLE_H

class req_fameshall_beginBattle{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_fameshall_beginBattle();
	void req_fameshall_beginBattle(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif