#ifndef MOF_REQ_RE_RECHARGE_STATUS_H
#define MOF_REQ_RE_RECHARGE_STATUS_H

class req_re_recharge_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_re_recharge_status();
	void req_re_recharge_status(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif