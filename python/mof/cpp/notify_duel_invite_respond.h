#ifndef MOF_NOTIFY_DUEL_INVITE_RESPOND_H
#define MOF_NOTIFY_DUEL_INVITE_RESPOND_H

class notify_duel_invite_respond{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_duel_invite_respond(void);
	void ~notify_duel_invite_respond();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif