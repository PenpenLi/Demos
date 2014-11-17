#ifndef MOF_ACK_BEGIN_PETCAMP_H
#define MOF_ACK_BEGIN_PETCAMP_H

class ack_begin_petcamp{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_begin_petcamp();
	void ack_begin_petcamp(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif