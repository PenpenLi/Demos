#ifndef MOF_NOTIFY_NEW_ROLES_H
#define MOF_NOTIFY_NEW_ROLES_H

class notify_new_roles{
public:
	void notify_new_roles(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_new_roles();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif