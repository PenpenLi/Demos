#ifndef MOF_NOTIFY_APP_CMD_H
#define MOF_NOTIFY_APP_CMD_H

class notify_app_cmd{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_app_cmd(void);
	void ~notify_app_cmd();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif