#ifndef MOF_NOTIFY_SYN_BATPOINT_H
#define MOF_NOTIFY_SYN_BATPOINT_H

class notify_syn_batpoint{
public:
	void decode(ByteArray	&);
	void ~notify_syn_batpoint();
	void PacketName(void);
	void encode(ByteArray	&);
	void notify_syn_batpoint(void);
	void build(ByteArray &);
}
#endif