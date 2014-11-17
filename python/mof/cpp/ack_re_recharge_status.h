#ifndef MOF_ACK_RE_RECHARGE_STATUS_H
#define MOF_ACK_RE_RECHARGE_STATUS_H

class ack_re_recharge_status{
public:
	void ack_re_recharge_status(void);
	void PacketName(void);
	void ~ack_re_recharge_status();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif