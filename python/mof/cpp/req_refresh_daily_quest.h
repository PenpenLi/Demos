#ifndef MOF_REQ_REFRESH_DAILY_QUEST_H
#define MOF_REQ_REFRESH_DAILY_QUEST_H

class req_refresh_daily_quest{
public:
	void req_refresh_daily_quest(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_refresh_daily_quest();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif