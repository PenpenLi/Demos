#ifndef MOF_REQ_GET_ROLE_DATA_H
#define MOF_REQ_GET_ROLE_DATA_H

class req_get_role_data{
public:
	void req_get_role_data(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_get_role_data();
}
#endif