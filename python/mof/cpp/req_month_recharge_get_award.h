#ifndef MOF_REQ_MONTH_RECHARGE_GET_AWARD_H
#define MOF_REQ_MONTH_RECHARGE_GET_AWARD_H

class req_month_recharge_get_award{
public:
	void req_month_recharge_get_award(void);
	void decode(ByteArray &);
	void ~req_month_recharge_get_award();
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif