#ifndef MOF_NOTIFY_ADDFRIEND_H
#define MOF_NOTIFY_ADDFRIEND_H

class notify_addfriend{
public:
	void notify_addfriend(void);
	void decode(ByteArray &);
	void ~notify_addfriend();
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif