#ifndef MOF_REQ_BEGIN_NORMAL_DUNGE_H
#define MOF_REQ_BEGIN_NORMAL_DUNGE_H

class req_begin_normal_dunge{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_begin_normal_dunge();
	void req_begin_normal_dunge(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif