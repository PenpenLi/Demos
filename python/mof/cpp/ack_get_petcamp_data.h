#ifndef MOF_ACK_GET_PETCAMP_DATA_H
#define MOF_ACK_GET_PETCAMP_DATA_H

class ack_get_petcamp_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_petcamp_data();
	void build(ByteArray	&);
	void ack_get_petcamp_data(void);
	void encode(ByteArray &);
}
#endif