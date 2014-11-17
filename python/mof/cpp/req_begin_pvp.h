#ifndef MOF_REQ_BEGIN_PVP_H
#define MOF_REQ_BEGIN_PVP_H

class req_begin_pvp{
public:
	void PacketName(void);
	void ~req_begin_pvp();
	void decode(ByteArray &);
	void req_begin_pvp(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif