#ifndef MOF_REQ_PVPRESULT_H
#define MOF_REQ_PVPRESULT_H

class req_PvpResult{
public:
	void req_PvpResult(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_PvpResult();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif