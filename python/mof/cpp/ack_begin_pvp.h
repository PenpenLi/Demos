#ifndef MOF_ACK_BEGIN_PVP_H
#define MOF_ACK_BEGIN_PVP_H

class ack_begin_pvp{
public:
	void ~ack_begin_pvp();
	void decode(ByteArray &);
	void ack_begin_pvp(void);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif