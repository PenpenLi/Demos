#ifndef MOF_ACK_CAPSULETOY_STATUS_H
#define MOF_ACK_CAPSULETOY_STATUS_H

class ack_capsuletoy_status{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_capsuletoy_status(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_capsuletoy_status();
}
#endif