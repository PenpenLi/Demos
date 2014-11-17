#ifndef MOF_ACK_GET_ACT_STATS_H
#define MOF_ACK_GET_ACT_STATS_H

class ack_get_act_stats{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_get_act_stats(void);
	void ~ack_get_act_stats();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif