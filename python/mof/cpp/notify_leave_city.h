#ifndef MOF_NOTIFY_LEAVE_CITY_H
#define MOF_NOTIFY_LEAVE_CITY_H

class notify_leave_city{
public:
	void decode(ByteArray &);
	void notify_leave_city(void);
	void PacketName(void);
	void ~notify_leave_city();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif