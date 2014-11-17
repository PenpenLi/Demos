#ifndef MOF_NOTIFY_SYNC_PET_STAGE_H
#define MOF_NOTIFY_SYNC_PET_STAGE_H

class notify_sync_pet_stage{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_pet_stage(void);
	void ~notify_sync_pet_stage();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif