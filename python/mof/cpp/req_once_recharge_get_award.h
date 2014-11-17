#ifndef MOF_REQ_ONCE_RECHARGE_GET_AWARD_H
#define MOF_REQ_ONCE_RECHARGE_GET_AWARD_H

class req_once_recharge_get_award{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_once_recharge_get_award();
	void req_once_recharge_get_award(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif