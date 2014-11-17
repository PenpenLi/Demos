#ifndef MOF_ACK_DUEL_INVITE_H
#define MOF_ACK_DUEL_INVITE_H

class ack_duel_invite{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_duel_invite(void);
	void ~ack_duel_invite();
}
#endif