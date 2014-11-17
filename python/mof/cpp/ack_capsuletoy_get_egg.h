#ifndef MOF_ACK_CAPSULETOY_GET_EGG_H
#define MOF_ACK_CAPSULETOY_GET_EGG_H

class ack_capsuletoy_get_egg{
public:
	void ~ack_capsuletoy_get_egg();
	void decode(ByteArray &);
	void ack_capsuletoy_get_egg(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif