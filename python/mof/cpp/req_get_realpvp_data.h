#ifndef MOF_REQ_GET_REALPVP_DATA_H
#define MOF_REQ_GET_REALPVP_DATA_H

class req_get_realpvp_data{
public:
	void ~req_get_realpvp_data();
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray	&);
	void encode(ByteArray &);
	void req_get_realpvp_data(void);
}
#endif