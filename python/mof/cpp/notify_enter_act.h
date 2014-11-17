#ifndef MOF_NOTIFY_ENTER_ACT_H
#define MOF_NOTIFY_ENTER_ACT_H

class notify_enter_act{
public:
	void notify_enter_act(void);
	void ~notify_enter_act();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif