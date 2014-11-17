#ifndef MOF_ACK_DUEL_INVITE_CANCEL_H
#define MOF_ACK_DUEL_INVITE_CANCEL_H

class ack_duel_invite_cancel{
public:
	void ~ack_duel_invite_cancel();
	void ack_duel_invite_cancel(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif