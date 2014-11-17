#ifndef MOF_REQ_DUNGCOPY_RESET_H
#define MOF_REQ_DUNGCOPY_RESET_H

class req_dungcopy_reset{
public:
	void req_dungcopy_reset(void);
	void decode(ByteArray &);
	void ~req_dungcopy_reset();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif