#ifndef MOF_ACK_APPLE_RECHARGE_H
#define MOF_ACK_APPLE_RECHARGE_H

class ack_apple_recharge{
public:
	void ack_apple_recharge(void);
	void ~ack_apple_recharge();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif