#ifndef MOF_NOTIFY_DUEL_INVITE_CANCEL_H
#define MOF_NOTIFY_DUEL_INVITE_CANCEL_H

class notify_duel_invite_cancel{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_duel_invite_cancel(void);
	void ~notify_duel_invite_cancel();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif