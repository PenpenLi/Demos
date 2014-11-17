#ifndef MOF_REQ_GETPVPAWARD_H
#define MOF_REQ_GETPVPAWARD_H

class req_getPvpAward{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_getPvpAward(void);
	void ~req_getPvpAward();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif