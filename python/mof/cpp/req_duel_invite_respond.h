#ifndef MOF_REQ_DUEL_INVITE_RESPOND_H
#define MOF_REQ_DUEL_INVITE_RESPOND_H

class req_duel_invite_respond{
public:
	void ~req_duel_invite_respond();
	void decode(ByteArray &);
	void req_duel_invite_respond(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif