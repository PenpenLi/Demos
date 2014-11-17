#ifndef MOF_ACK_UPDATE_ACT_STATS_H
#define MOF_ACK_UPDATE_ACT_STATS_H

class ack_update_act_stats{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_update_act_stats();
	void ack_update_act_stats(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif