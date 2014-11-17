#ifndef MOF_NOTIFY_REALPVP_MATCHING_INFO_H
#define MOF_NOTIFY_REALPVP_MATCHING_INFO_H

class notify_realpvp_matching_info{
public:
	void decode(ByteArray &);
	void notify_realpvp_matching_info(void);
	void PacketName(void);
	void encode(ByteArray &);
	void build(ByteArray	&);
	void ~notify_realpvp_matching_info();
}
#endif