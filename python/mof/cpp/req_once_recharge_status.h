#ifndef MOF_REQ_ONCE_RECHARGE_STATUS_H
#define MOF_REQ_ONCE_RECHARGE_STATUS_H

class req_once_recharge_status{
public:
	void req_once_recharge_status(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_once_recharge_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif