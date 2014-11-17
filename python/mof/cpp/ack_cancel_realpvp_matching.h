#ifndef MOF_ACK_CANCEL_REALPVP_MATCHING_H
#define MOF_ACK_CANCEL_REALPVP_MATCHING_H

class ack_cancel_realpvp_matching{
public:
	void decode(ByteArray	&);
	void ack_cancel_realpvp_matching(void);
	void PacketName(void);
	void ~ack_cancel_realpvp_matching();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif