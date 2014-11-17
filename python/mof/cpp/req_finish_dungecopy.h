#ifndef MOF_REQ_FINISH_DUNGECOPY_H
#define MOF_REQ_FINISH_DUNGECOPY_H

class req_finish_dungecopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_finish_dungecopy();
	void build(ByteArray	&);
	void req_finish_dungecopy(void);
	void encode(ByteArray &);
}
#endif