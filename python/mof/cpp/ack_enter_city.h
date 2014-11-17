#ifndef MOF_ACK_ENTER_CITY_H
#define MOF_ACK_ENTER_CITY_H

class ack_enter_city{
public:
	void ack_enter_city(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_enter_city();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif