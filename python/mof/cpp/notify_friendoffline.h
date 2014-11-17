#ifndef MOF_NOTIFY_FRIENDOFFLINE_H
#define MOF_NOTIFY_FRIENDOFFLINE_H

class notify_friendoffline{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_friendoffline(void);
	void ~notify_friendoffline();
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif