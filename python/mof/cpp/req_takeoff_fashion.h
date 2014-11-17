#ifndef MOF_REQ_TAKEOFF_FASHION_H
#define MOF_REQ_TAKEOFF_FASHION_H

class req_takeoff_fashion{
public:
	void decode(ByteArray	&);
	void req_takeoff_fashion(void);
	void ~req_takeoff_fashion();
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif