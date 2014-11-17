#ifndef MOF_REQ_DUEL_INVITE_CANCEL_H
#define MOF_REQ_DUEL_INVITE_CANCEL_H

class req_duel_invite_cancel{
public:
	void req_duel_invite_cancel(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_duel_invite_cancel();
}
#endif