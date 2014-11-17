#ifndef MOF_ACK_BEGIN_NORMAL_DUNGE_H
#define MOF_ACK_BEGIN_NORMAL_DUNGE_H

class ack_begin_normal_dunge{
public:
	void ack_begin_normal_dunge(void);
	void ~ack_begin_normal_dunge();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif