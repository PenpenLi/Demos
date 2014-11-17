#ifndef MOF_ACK_ACC_CONSUME_STATUS_H
#define MOF_ACK_ACC_CONSUME_STATUS_H

class ack_acc_consume_status{
public:
	void ack_acc_consume_status(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_acc_consume_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif