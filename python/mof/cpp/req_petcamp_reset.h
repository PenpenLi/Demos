#ifndef MOF_REQ_PETCAMP_RESET_H
#define MOF_REQ_PETCAMP_RESET_H

class req_petcamp_reset{
public:
	void ~req_petcamp_reset();
	void decode(ByteArray &);
	void PacketName(void);
	void req_petcamp_reset(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif