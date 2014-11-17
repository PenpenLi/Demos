#ifndef MOF_ACK_RE_RECHARGE_GET_AWARD_H
#define MOF_ACK_RE_RECHARGE_GET_AWARD_H

class ack_re_recharge_get_award{
public:
	void ~ack_re_recharge_get_award();
	void ack_re_recharge_get_award(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif