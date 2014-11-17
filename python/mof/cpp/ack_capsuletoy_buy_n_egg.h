#ifndef MOF_ACK_CAPSULETOY_BUY_N_EGG_H
#define MOF_ACK_CAPSULETOY_BUY_N_EGG_H

class ack_capsuletoy_buy_n_egg{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_capsuletoy_buy_n_egg(void);
	void ~ack_capsuletoy_buy_n_egg();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif