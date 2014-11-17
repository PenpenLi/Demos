#ifndef MOF_REQ_ACC_RECHARGE_STATUS_H
#define MOF_REQ_ACC_RECHARGE_STATUS_H

class req_acc_recharge_status{
public:
	void req_acc_recharge_status(void);
	void ~req_acc_recharge_status();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif