#ifndef MOF_NOTIFY_ROLE_PROP_INFO_H
#define MOF_NOTIFY_ROLE_PROP_INFO_H

class notify_role_prop_info{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_role_prop_info(void);
	void ~notify_role_prop_info();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif