#ifndef MOF_NOTIFY_ADDQUEST_H
#define MOF_NOTIFY_ADDQUEST_H

class notify_addQuest{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_addQuest(void);
	void ~notify_addQuest();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif