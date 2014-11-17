#ifndef MOF_ACK_ONCE_RECHARGE_STATUS_H
#define MOF_ACK_ONCE_RECHARGE_STATUS_H

class ack_once_recharge_status{
public:
	void ~ack_once_recharge_status();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_once_recharge_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif