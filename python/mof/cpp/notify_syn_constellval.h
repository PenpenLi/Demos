#ifndef MOF_NOTIFY_SYN_CONSTELLVAL_H
#define MOF_NOTIFY_SYN_CONSTELLVAL_H

class notify_syn_constellval{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_constellval(void);
	void ~notify_syn_constellval();
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif