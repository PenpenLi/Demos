#ifndef MOF_ACK_GET_PETPVP_DATA_H
#define MOF_ACK_GET_PETPVP_DATA_H

class ack_get_petpvp_data{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ack_get_petpvp_data(void);
	void ~ack_get_petpvp_data();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif