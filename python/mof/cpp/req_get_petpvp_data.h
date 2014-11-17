#ifndef MOF_REQ_GET_PETPVP_DATA_H
#define MOF_REQ_GET_PETPVP_DATA_H

class req_get_petpvp_data{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~req_get_petpvp_data();
	void encode(ByteArray	&);
	void req_get_petpvp_data(void);
	void build(ByteArray &);
}
#endif