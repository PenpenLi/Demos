#ifndef MOF_REQ_ACC_CONSUME_STATUS_H
#define MOF_REQ_ACC_CONSUME_STATUS_H

class req_acc_consume_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_acc_consume_status(void);
	void ~req_acc_consume_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif