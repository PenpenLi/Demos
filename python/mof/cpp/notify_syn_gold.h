#ifndef MOF_NOTIFY_SYN_GOLD_H
#define MOF_NOTIFY_SYN_GOLD_H

class notify_syn_gold{
public:
	void ~notify_syn_gold();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_gold(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif