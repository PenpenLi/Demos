#ifndef MOF_NOTIFY_REFRESH_TLK_MONSTER_H
#define MOF_NOTIFY_REFRESH_TLK_MONSTER_H

class notify_refresh_tlk_monster{
public:
	void notify_refresh_tlk_monster(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_refresh_tlk_monster();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif