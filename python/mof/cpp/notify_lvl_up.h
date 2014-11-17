#ifndef MOF_NOTIFY_LVL_UP_H
#define MOF_NOTIFY_LVL_UP_H

class notify_lvl_up{
public:
	void ~notify_lvl_up();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_lvl_up(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif