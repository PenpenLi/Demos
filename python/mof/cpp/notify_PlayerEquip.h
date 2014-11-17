#ifndef MOF_NOTIFY_PLAYEREQUIP_H
#define MOF_NOTIFY_PLAYEREQUIP_H

class notify_PlayerEquip{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_PlayerEquip();
	void notify_PlayerEquip(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif