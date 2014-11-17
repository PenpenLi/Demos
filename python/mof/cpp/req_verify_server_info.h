#ifndef MOF_REQ_VERIFY_SERVER_INFO_H
#define MOF_REQ_VERIFY_SERVER_INFO_H

class req_verify_server_info{
public:
	void ~req_verify_server_info();
	void decode(ByteArray &);
	void PacketName(void);
	void req_verify_server_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif