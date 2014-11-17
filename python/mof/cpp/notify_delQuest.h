#ifndef MOF_NOTIFY_DELQUEST_H
#define MOF_NOTIFY_DELQUEST_H

class notify_delQuest{
public:
	void ~notify_delQuest();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_delQuest(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif