#ifndef MOF_NOTIFY_HONOR_GET_H
#define MOF_NOTIFY_HONOR_GET_H

class notify_honor_get{
public:
	void notify_honor_get(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_honor_get();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif