#ifndef MOF_REQ_BEREADYTO_REALPVP_MATCHING_H
#define MOF_REQ_BEREADYTO_REALPVP_MATCHING_H

class req_bereadyto_realpvp_matching{
public:
	void req_bereadyto_realpvp_matching(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_bereadyto_realpvp_matching();
}
#endif