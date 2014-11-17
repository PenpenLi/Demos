#ifndef MOF_ACK_MONTH_RECHARGE_GET_AWARD_H
#define MOF_ACK_MONTH_RECHARGE_GET_AWARD_H

class ack_month_recharge_get_award{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_month_recharge_get_award(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
	void ~ack_month_recharge_get_award();
}
#endif