#ifndef MOF_REQ_CAPSULETOY_STATUS_H
#define MOF_REQ_CAPSULETOY_STATUS_H

class req_capsuletoy_status{
public:
	void req_capsuletoy_status(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_capsuletoy_status();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif