#ifndef MOF_NOTIFY_DUNGLEVELRECORD_H
#define MOF_NOTIFY_DUNGLEVELRECORD_H

class notify_dunglevelrecord{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_dunglevelrecord(void);
	void ~notify_dunglevelrecord();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif