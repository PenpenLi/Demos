#ifndef MOF_NOTIFY_EDIT_INTIMACY_H
#define MOF_NOTIFY_EDIT_INTIMACY_H

class notify_edit_intimacy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_edit_intimacy();
	void notify_edit_intimacy(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif