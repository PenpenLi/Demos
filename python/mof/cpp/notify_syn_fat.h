#ifndef MOF_NOTIFY_SYN_FAT_H
#define MOF_NOTIFY_SYN_FAT_H

class notify_syn_fat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_syn_fat(void);
	void ~notify_syn_fat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif