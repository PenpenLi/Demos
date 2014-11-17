#ifndef MOF_NOTIFY_DISCONNECT_TIP_H
#define MOF_NOTIFY_DISCONNECT_TIP_H

class notify_disconnect_tip{
public:
	void notify_disconnect_tip(void);
	void ~notify_disconnect_tip();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif