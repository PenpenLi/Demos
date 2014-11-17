#ifndef MOF_REQ_ACC_RECHARGE_GET_AWARD_H
#define MOF_REQ_ACC_RECHARGE_GET_AWARD_H

class req_acc_recharge_get_award{
public:
	void decode(ByteArray &);
	void ~req_acc_recharge_get_award();
	void PacketName(void);
	void req_acc_recharge_get_award(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif