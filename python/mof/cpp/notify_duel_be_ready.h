#ifndef MOF_NOTIFY_DUEL_BE_READY_H
#define MOF_NOTIFY_DUEL_BE_READY_H

class notify_duel_be_ready{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_duel_be_ready();
	void notify_duel_be_ready(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif