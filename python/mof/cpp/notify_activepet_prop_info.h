#ifndef MOF_NOTIFY_ACTIVEPET_PROP_INFO_H
#define MOF_NOTIFY_ACTIVEPET_PROP_INFO_H

class notify_activepet_prop_info{
public:
	void ~notify_activepet_prop_info();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_activepet_prop_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif