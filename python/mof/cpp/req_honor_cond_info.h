#ifndef MOF_REQ_HONOR_COND_INFO_H
#define MOF_REQ_HONOR_COND_INFO_H

class req_honor_cond_info{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_honor_cond_info();
	void req_honor_cond_info(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif