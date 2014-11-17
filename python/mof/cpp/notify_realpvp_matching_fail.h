#ifndef MOF_NOTIFY_REALPVP_MATCHING_FAIL_H
#define MOF_NOTIFY_REALPVP_MATCHING_FAIL_H

class notify_realpvp_matching_fail{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_realpvp_matching_fail();
	void notify_realpvp_matching_fail(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif