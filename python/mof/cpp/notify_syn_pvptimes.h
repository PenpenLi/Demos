#ifndef MOF_NOTIFY_SYN_PVPTIMES_H
#define MOF_NOTIFY_SYN_PVPTIMES_H

class notify_syn_pvptimes{
public:
	void ~notify_syn_pvptimes();
	void decode(ByteArray	&);
	void PacketName(void);
	void notify_syn_pvptimes(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif