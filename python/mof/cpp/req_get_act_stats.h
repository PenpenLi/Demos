#ifndef MOF_REQ_GET_ACT_STATS_H
#define MOF_REQ_GET_ACT_STATS_H

class req_get_act_stats{
public:
	void req_get_act_stats(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_get_act_stats();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif