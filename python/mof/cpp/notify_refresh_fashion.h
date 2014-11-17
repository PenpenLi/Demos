#ifndef MOF_NOTIFY_REFRESH_FASHION_H
#define MOF_NOTIFY_REFRESH_FASHION_H

class notify_refresh_fashion{
public:
	void notify_refresh_fashion(void);
	void decode(ByteArray &);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray &);
	void ~notify_refresh_fashion();
}
#endif