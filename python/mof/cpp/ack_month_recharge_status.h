#ifndef MOF_ACK_MONTH_RECHARGE_STATUS_H
#define MOF_ACK_MONTH_RECHARGE_STATUS_H

class ack_month_recharge_status{
public:
	void ~ack_month_recharge_status();
	void PacketName(void);
	void decode(ByteArray &);
	void ack_month_recharge_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif