#ifndef MOF_NOTIFY_GET_PET_H
#define MOF_NOTIFY_GET_PET_H

class notify_get_pet{
public:
	void decode(ByteArray &);
	void ~notify_get_pet();
	void PacketName(void);
	void notify_get_pet(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif