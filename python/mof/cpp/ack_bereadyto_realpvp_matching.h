#ifndef MOF_ACK_BEREADYTO_REALPVP_MATCHING_H
#define MOF_ACK_BEREADYTO_REALPVP_MATCHING_H

class ack_bereadyto_realpvp_matching{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~ack_bereadyto_realpvp_matching();
	void build(ByteArray &);
	void ack_bereadyto_realpvp_matching(void);
}
#endif