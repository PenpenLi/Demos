#ifndef MOF_ACK_ONCE_RECHARGE_GET_AWARD_H
#define MOF_ACK_ONCE_RECHARGE_GET_AWARD_H

class ack_once_recharge_get_award{
public:
	void decode(ByteArray	&);
	void ack_once_recharge_get_award(void);
	void PacketName(void);
	void ~ack_once_recharge_get_award();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif