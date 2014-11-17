#ifndef MOF_ACK_ACC_RECHARGE_GET_AWARD_H
#define MOF_ACK_ACC_RECHARGE_GET_AWARD_H

class ack_acc_recharge_get_award{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_acc_recharge_get_award();
	void build(ByteArray &);
	void ack_acc_recharge_get_award(void);
}
#endif