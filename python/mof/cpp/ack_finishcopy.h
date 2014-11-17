#ifndef MOF_ACK_FINISHCOPY_H
#define MOF_ACK_FINISHCOPY_H

class ack_finishcopy{
public:
	void ~ack_finishcopy();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_finishcopy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif