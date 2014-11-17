#ifndef MOF_NOTIFY_SYNC_PET_EXP_H
#define MOF_NOTIFY_SYNC_PET_EXP_H

class notify_sync_pet_exp{
public:
	void decode(ByteArray	&);
	void ~notify_sync_pet_exp();
	void PacketName(void);
	void notify_sync_pet_exp(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif