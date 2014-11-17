#ifndef MOF_NOTIFY_TREASURECOPY_ACTIVITY_RESULT_H
#define MOF_NOTIFY_TREASURECOPY_ACTIVITY_RESULT_H

class notify_treasurecopy_activity_result{
public:
	void notify_treasurecopy_activity_result(void);
	void decode(ByteArray	&);
	void PacketName(void);
	void ~notify_treasurecopy_activity_result();
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif