#ifndef MOF_REQ_CAPSULETOY_GET_EGG_H
#define MOF_REQ_CAPSULETOY_GET_EGG_H

class req_capsuletoy_get_egg{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_capsuletoy_get_egg(void);
	void ~req_capsuletoy_get_egg();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif