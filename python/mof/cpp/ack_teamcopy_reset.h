#ifndef MOF_ACK_TEAMCOPY_RESET_H
#define MOF_ACK_TEAMCOPY_RESET_H

class ack_teamcopy_reset{
public:
	void decode(ByteArray &);
	void ack_teamcopy_reset(void);
	void PacketName(void);
	void ~ack_teamcopy_reset();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif