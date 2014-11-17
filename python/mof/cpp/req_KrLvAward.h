#ifndef MOF_REQ_KRLVAWARD_H
#define MOF_REQ_KRLVAWARD_H

class req_KrLvAward{
public:
	void req_KrLvAward(void);
	void ~req_KrLvAward();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif