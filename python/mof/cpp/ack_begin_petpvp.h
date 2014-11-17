#ifndef MOF_ACK_BEGIN_PETPVP_H
#define MOF_ACK_BEGIN_PETPVP_H

class ack_begin_petpvp{
public:
	void decode(ByteArray &);
	void ~ack_begin_petpvp();
	void PacketName(void);
	void ack_begin_petpvp(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif