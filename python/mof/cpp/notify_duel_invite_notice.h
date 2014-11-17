#ifndef MOF_NOTIFY_DUEL_INVITE_NOTICE_H
#define MOF_NOTIFY_DUEL_INVITE_NOTICE_H

class notify_duel_invite_notice{
public:
	void notify_duel_invite_notice(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_duel_invite_notice();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif