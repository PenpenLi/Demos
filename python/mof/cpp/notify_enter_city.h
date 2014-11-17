#ifndef MOF_NOTIFY_ENTER_CITY_H
#define MOF_NOTIFY_ENTER_CITY_H

class notify_enter_city{
public:
	void decode(ByteArray &);
	void notify_enter_city(void);
	void PacketName(void);
	void ~notify_enter_city();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif