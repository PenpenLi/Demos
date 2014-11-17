#ifndef MOF_NOTIFY_AGREEFRIEND_H
#define MOF_NOTIFY_AGREEFRIEND_H

class notify_agreefriend{
public:
	void ~notify_agreefriend();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void notify_agreefriend(void);
}
#endif