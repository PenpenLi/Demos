#ifndef MOF_REQ_DUEL_INVITE_H
#define MOF_REQ_DUEL_INVITE_H

class req_duel_invite{
public:
	void req_duel_invite(void);
	void PacketName(void);
	void ~req_duel_invite();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif