#ifndef MOF_NOTIFY_SYN_DAILYCOUNT_H
#define MOF_NOTIFY_SYN_DAILYCOUNT_H

class notify_syn_dailycount{
public:
	void decode(ByteArray &);
	void ~notify_syn_dailycount();
	void PacketName(void);
	void notify_syn_dailycount(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif