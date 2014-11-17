#ifndef MOF_ACK_FRESH_PVP_IMMEDIATELY_H
#define MOF_ACK_FRESH_PVP_IMMEDIATELY_H

class ack_fresh_pvp_immediately{
public:
	void ack_fresh_pvp_immediately(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_fresh_pvp_immediately();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif