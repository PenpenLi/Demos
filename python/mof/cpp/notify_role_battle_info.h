#ifndef MOF_NOTIFY_ROLE_BATTLE_INFO_H
#define MOF_NOTIFY_ROLE_BATTLE_INFO_H

class notify_role_battle_info{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_role_battle_info();
	void notify_role_battle_info(void);
	void operator=(notify_role_battle_info const&);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif