#ifndef MOF_NOTIFY_SYN_VIPEXP_H
#define MOF_NOTIFY_SYN_VIPEXP_H

class notify_syn_vipexp{
public:
	void notify_syn_vipexp(void);
	void ~notify_syn_vipexp();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif