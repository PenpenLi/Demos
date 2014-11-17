#ifndef MOF_REQ_MONTH_RECHARGE_STATUS_H
#define MOF_REQ_MONTH_RECHARGE_STATUS_H

class req_month_recharge_status{
public:
	void decode(ByteArray &);
	void req_month_recharge_status(void);
	void PacketName(void);
	void ~req_month_recharge_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif