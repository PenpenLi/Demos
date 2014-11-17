#ifndef MOF_NOTIFY_SYN_PETELITETIMES_H
#define MOF_NOTIFY_SYN_PETELITETIMES_H

class notify_syn_petelitetimes{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_petelitetimes(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~notify_syn_petelitetimes();
}
#endif