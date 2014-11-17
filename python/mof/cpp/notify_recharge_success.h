#ifndef MOF_NOTIFY_RECHARGE_SUCCESS_H
#define MOF_NOTIFY_RECHARGE_SUCCESS_H

class notify_recharge_success{
public:
	void decode(ByteArray &);
	void notify_recharge_success(void);
	void PacketName(void);
	void ~notify_recharge_success();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif