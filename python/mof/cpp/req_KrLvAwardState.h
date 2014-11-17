#ifndef MOF_REQ_KRLVAWARDSTATE_H
#define MOF_REQ_KRLVAWARDSTATE_H

class req_KrLvAwardState{
public:
	void ~req_KrLvAwardState();
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void req_KrLvAwardState(void);
}
#endif