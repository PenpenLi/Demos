#ifndef MOF_REQ_GETPVPRANK_H
#define MOF_REQ_GETPVPRANK_H

class req_getPvpRank{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_getPvpRank(void);
	void ~req_getPvpRank();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif