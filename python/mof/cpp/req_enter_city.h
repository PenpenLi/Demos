#ifndef MOF_REQ_ENTER_CITY_H
#define MOF_REQ_ENTER_CITY_H

class req_enter_city{
public:
	void ~req_enter_city();
	void req_enter_city(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif