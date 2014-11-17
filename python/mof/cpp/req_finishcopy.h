#ifndef MOF_REQ_FINISHCOPY_H
#define MOF_REQ_FINISHCOPY_H

class req_finishcopy{
public:
	void req_finishcopy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_finishcopy();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif