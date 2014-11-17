#ifndef MOF_NOTIFY_SYNC_PET_PROP_H
#define MOF_NOTIFY_SYNC_PET_PROP_H

class notify_sync_pet_prop{
public:
	void notify_sync_pet_prop(void);
	void ~notify_sync_pet_prop();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif