#ifndef MOF_ACK_ACC_CONSUME_GET_AWARD_H
#define MOF_ACK_ACC_CONSUME_GET_AWARD_H

class ack_acc_consume_get_award{
public:
	void ~ack_acc_consume_get_award();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_acc_consume_get_award(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif