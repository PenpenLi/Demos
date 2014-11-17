#ifndef MOF_REQ_ACC_CONSUME_GET_AWARD_H
#define MOF_REQ_ACC_CONSUME_GET_AWARD_H

class req_acc_consume_get_award{
public:
	void ~req_acc_consume_get_award();
	void decode(ByteArray &);
	void PacketName(void);
	void req_acc_consume_get_award(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif