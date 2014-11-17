#ifndef MOF_REQ_HONOR_H
#define MOF_REQ_HONOR_H

class req_honor{
public:
	void ~req_honor();
	void decode(ByteArray &);
	void PacketName(void);
	void req_honor(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif