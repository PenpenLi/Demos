#ifndef MOF_NOTIFY_ADD_FASHION_H
#define MOF_NOTIFY_ADD_FASHION_H

class notify_add_fashion{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_add_fashion();
	void notify_add_fashion(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif