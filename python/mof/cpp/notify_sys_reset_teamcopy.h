#ifndef MOF_NOTIFY_SYS_RESET_TEAMCOPY_H
#define MOF_NOTIFY_SYS_RESET_TEAMCOPY_H

class notify_sys_reset_teamcopy{
public:
	void ~notify_sys_reset_teamcopy();
	void notify_sys_reset_teamcopy(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif