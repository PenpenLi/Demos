#ifndef MOF_ACK_VERIFY_SERVER_INFO_H
#define MOF_ACK_VERIFY_SERVER_INFO_H

class ack_verify_server_info{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_verify_server_info(void);
	void ~ack_verify_server_info();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif