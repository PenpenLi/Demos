#ifndef MOF_ACK_ACC_RECHARGE_STATUS_H
#define MOF_ACK_ACC_RECHARGE_STATUS_H

class ack_acc_recharge_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_acc_recharge_status();
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_acc_recharge_status(void);
}
#endif