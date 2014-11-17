#ifndef MOF_ACK_GET_TOWERDEFENSE_DATA_H
#define MOF_ACK_GET_TOWERDEFENSE_DATA_H

class ack_get_towerdefense_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_get_towerdefense_data();
	void build(ByteArray &);
	void encode(ByteArray &);
	void ack_get_towerdefense_data(void);
}
#endif