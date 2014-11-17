#ifndef MOF_NOTIFY_SYN_VIPLVLAWARD_H
#define MOF_NOTIFY_SYN_VIPLVLAWARD_H

class notify_syn_viplvlaward{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_viplvlaward(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~notify_syn_viplvlaward();
}
#endif