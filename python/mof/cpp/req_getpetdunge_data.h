#ifndef MOF_REQ_GETPETDUNGE_DATA_H
#define MOF_REQ_GETPETDUNGE_DATA_H

class req_getpetdunge_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_getpetdunge_data(void);
	void ~req_getpetdunge_data();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif