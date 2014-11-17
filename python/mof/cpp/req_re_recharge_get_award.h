#ifndef MOF_REQ_RE_RECHARGE_GET_AWARD_H
#define MOF_REQ_RE_RECHARGE_GET_AWARD_H

class req_re_recharge_get_award{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_re_recharge_get_award();
	void req_re_recharge_get_award(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif