#ifndef MOF_ACK_REFRESH_DAILY_QUEST_H
#define MOF_ACK_REFRESH_DAILY_QUEST_H

class ack_refresh_daily_quest{
public:
	void ack_refresh_daily_quest(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_refresh_daily_quest();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif