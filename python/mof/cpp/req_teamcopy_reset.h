#ifndef MOF_REQ_TEAMCOPY_RESET_H
#define MOF_REQ_TEAMCOPY_RESET_H

class req_teamcopy_reset{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_teamcopy_reset(void);
	void ~req_teamcopy_reset();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif