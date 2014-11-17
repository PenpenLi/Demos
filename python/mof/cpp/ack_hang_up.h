#ifndef MOF_ACK_HANG_UP_H
#define MOF_ACK_HANG_UP_H

class ack_hang_up{
public:
	void ack_hang_up(void);
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
	void ~ack_hang_up();
}
#endif