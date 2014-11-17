#ifndef MOF_REQ_CAPSULETOY_BUY_N_EGG_H
#define MOF_REQ_CAPSULETOY_BUY_N_EGG_H

class req_capsuletoy_buy_n_egg{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_capsuletoy_buy_n_egg(void);
	void ~req_capsuletoy_buy_n_egg();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif