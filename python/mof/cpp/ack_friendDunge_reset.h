#ifndef MOF_ACK_FRIENDDUNGE_RESET_H
#define MOF_ACK_FRIENDDUNGE_RESET_H

class ack_friendDunge_reset{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_friendDunge_reset(void);
	void ~ack_friendDunge_reset();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif