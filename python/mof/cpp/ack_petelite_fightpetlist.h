#ifndef MOF_ACK_PETELITE_FIGHTPETLIST_H
#define MOF_ACK_PETELITE_FIGHTPETLIST_H

class ack_petelite_fightpetlist{
public:
	void decode(ByteArray &);
	void ack_petelite_fightpetlist(void);
	void PacketName(void);
	void ~ack_petelite_fightpetlist();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif