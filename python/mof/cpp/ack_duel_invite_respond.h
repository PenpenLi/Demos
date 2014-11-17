#ifndef MOF_ACK_DUEL_INVITE_RESPOND_H
#define MOF_ACK_DUEL_INVITE_RESPOND_H

class ack_duel_invite_respond{
public:
	void ~ack_duel_invite_respond();
	void ack_duel_invite_respond(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif