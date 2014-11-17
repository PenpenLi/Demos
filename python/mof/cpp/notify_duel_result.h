#ifndef MOF_NOTIFY_DUEL_RESULT_H
#define MOF_NOTIFY_DUEL_RESULT_H

class notify_duel_result{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_duel_result();
	void notify_duel_result(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif