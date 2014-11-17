#ifndef MOF_REQ_BEGIN_PETPVP_H
#define MOF_REQ_BEGIN_PETPVP_H

class req_begin_petpvp{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_begin_petpvp(void);
	void ~req_begin_petpvp();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif