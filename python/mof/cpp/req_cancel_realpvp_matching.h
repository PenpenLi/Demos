#ifndef MOF_REQ_CANCEL_REALPVP_MATCHING_H
#define MOF_REQ_CANCEL_REALPVP_MATCHING_H

class req_cancel_realpvp_matching{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void req_cancel_realpvp_matching(void);
	void ~req_cancel_realpvp_matching();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif