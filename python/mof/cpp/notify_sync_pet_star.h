#ifndef MOF_NOTIFY_SYNC_PET_STAR_H
#define MOF_NOTIFY_SYNC_PET_STAR_H

class notify_sync_pet_star{
public:
	void notify_sync_pet_star(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_sync_pet_star();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif