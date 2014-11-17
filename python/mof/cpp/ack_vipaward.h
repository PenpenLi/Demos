#ifndef MOF_ACK_VIPAWARD_H
#define MOF_ACK_VIPAWARD_H

class ack_vipaward{
public:
	void ack_vipaward(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_vipaward();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif