#ifndef MOF_NOTIFY_SYN_RMB_H
#define MOF_NOTIFY_SYN_RMB_H

class notify_syn_rmb{
public:
	void notify_syn_rmb(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_syn_rmb();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif