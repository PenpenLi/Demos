#ifndef MOF_REQ_FRESH_PVP_IMMEDIATELY_H
#define MOF_REQ_FRESH_PVP_IMMEDIATELY_H

class req_fresh_pvp_immediately{
public:
	void req_fresh_pvp_immediately(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_fresh_pvp_immediately();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif