#ifndef MOF_REQ_HONOR_USE_H
#define MOF_REQ_HONOR_USE_H

class req_honor_use{
public:
	void req_honor_use(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_honor_use();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif