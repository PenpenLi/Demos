#ifndef MOF_REQ_GET_TREASURE_COPY_DATA_H
#define MOF_REQ_GET_TREASURE_COPY_DATA_H

class req_get_treasure_copy_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void ~req_get_treasure_copy_data();
	void build(ByteArray &);
	void req_get_treasure_copy_data(void);
}
#endif