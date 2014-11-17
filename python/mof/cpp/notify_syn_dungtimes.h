#ifndef MOF_NOTIFY_SYN_DUNGTIMES_H
#define MOF_NOTIFY_SYN_DUNGTIMES_H

class notify_syn_dungtimes{
public:
	void ~notify_syn_dungtimes();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_dungtimes(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif