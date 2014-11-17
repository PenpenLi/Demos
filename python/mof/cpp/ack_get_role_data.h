#ifndef MOF_ACK_GET_ROLE_DATA_H
#define MOF_ACK_GET_ROLE_DATA_H

class ack_get_role_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_role_data();
	void ack_get_role_data(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif