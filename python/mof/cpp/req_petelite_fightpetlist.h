#ifndef MOF_REQ_PETELITE_FIGHTPETLIST_H
#define MOF_REQ_PETELITE_FIGHTPETLIST_H

class req_petelite_fightpetlist{
public:
	void decode(ByteArray &);
	void ~req_petelite_fightpetlist();
	void PacketName(void);
	void req_petelite_fightpetlist(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif