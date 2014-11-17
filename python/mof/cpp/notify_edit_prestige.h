#ifndef MOF_NOTIFY_EDIT_PRESTIGE_H
#define MOF_NOTIFY_EDIT_PRESTIGE_H

class notify_edit_prestige{
public:
	void decode(ByteArray &);
	void ~notify_edit_prestige();
	void PacketName(void);
	void notify_edit_prestige(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif