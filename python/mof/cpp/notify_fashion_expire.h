#ifndef MOF_NOTIFY_FASHION_EXPIRE_H
#define MOF_NOTIFY_FASHION_EXPIRE_H

class notify_fashion_expire{
public:
	void ~notify_fashion_expire();
	void PacketName(void);
	void notify_fashion_expire(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif