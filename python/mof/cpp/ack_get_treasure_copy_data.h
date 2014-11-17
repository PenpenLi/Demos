#ifndef MOF_ACK_GET_TREASURE_COPY_DATA_H
#define MOF_ACK_GET_TREASURE_COPY_DATA_H

class ack_get_treasure_copy_data{
public:
	void ~ack_get_treasure_copy_data();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_get_treasure_copy_data(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif