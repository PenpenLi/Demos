#ifndef MOF_ACK_CAPSULETOY_BUY_EGG_H
#define MOF_ACK_CAPSULETOY_BUY_EGG_H

class ack_capsuletoy_buy_egg{
public:
	void ~ack_capsuletoy_buy_egg();
	void ack_capsuletoy_buy_egg(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif