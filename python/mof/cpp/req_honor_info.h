#ifndef MOF_REQ_HONOR_INFO_H
#define MOF_REQ_HONOR_INFO_H

class req_honor_info{
public:
	void ~req_honor_info();
	void decode(ByteArray &);
	void PacketName(void);
	void req_honor_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif