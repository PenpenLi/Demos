#ifndef MOF_REQ_GETPAIHANGDATA_H
#define MOF_REQ_GETPAIHANGDATA_H

class req_getPaihangData{
public:
	void req_getPaihangData(void);
	void ~req_getPaihangData();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif