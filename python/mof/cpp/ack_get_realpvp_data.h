#ifndef MOF_ACK_GET_REALPVP_DATA_H
#define MOF_ACK_GET_REALPVP_DATA_H

class ack_get_realpvp_data{
public:
	void ack_get_realpvp_data(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_realpvp_data();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif