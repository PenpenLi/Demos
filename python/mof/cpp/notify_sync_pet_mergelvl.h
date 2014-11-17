#ifndef MOF_NOTIFY_SYNC_PET_MERGELVL_H
#define MOF_NOTIFY_SYNC_PET_MERGELVL_H

class notify_sync_pet_mergelvl{
public:
	void notify_sync_pet_mergelvl(void);
	void ~notify_sync_pet_mergelvl();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif