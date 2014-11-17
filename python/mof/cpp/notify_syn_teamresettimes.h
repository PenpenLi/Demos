#ifndef MOF_NOTIFY_SYN_TEAMRESETTIMES_H
#define MOF_NOTIFY_SYN_TEAMRESETTIMES_H

class notify_syn_teamresettimes{
public:
	void ~notify_syn_teamresettimes();
	void notify_syn_teamresettimes(void);
	void PacketName(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif