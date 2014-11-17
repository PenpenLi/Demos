#ifndef MOF_NOTIFY_SYN_ELITETIMES_H
#define MOF_NOTIFY_SYN_ELITETIMES_H

class notify_syn_elitetimes{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_syn_elitetimes();
	void notify_syn_elitetimes(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif