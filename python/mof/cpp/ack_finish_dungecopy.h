#ifndef MOF_ACK_FINISH_DUNGECOPY_H
#define MOF_ACK_FINISH_DUNGECOPY_H

class ack_finish_dungecopy{
public:
	void ack_finish_dungecopy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void ~ack_finish_dungecopy();
	void encode(ByteArray &);
}
#endif