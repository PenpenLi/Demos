#ifndef MOF_NOTIFY_SYN_VIPLVL_H
#define MOF_NOTIFY_SYN_VIPLVL_H

class notify_syn_viplvl{
public:
	void decode(ByteArray &);
	void notify_syn_viplvl(void);
	void PacketName(void);
	void ~notify_syn_viplvl();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif