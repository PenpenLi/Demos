#ifndef MOF_REQ_BEGIN_PETCAMP_H
#define MOF_REQ_BEGIN_PETCAMP_H

class req_begin_petcamp{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_begin_petcamp();
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_begin_petcamp(void);
}
#endif