#ifndef MOF_NOTIFY_DELETE_APPLY_H
#define MOF_NOTIFY_DELETE_APPLY_H

class notify_delete_apply{
public:
	void notify_delete_apply(void);
	void decode(ByteArray	&);
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
	void ~notify_delete_apply();
}
#endif