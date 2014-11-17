#ifndef MOF_NOTIFY_FRIENDONLINE_H
#define MOF_NOTIFY_FRIENDONLINE_H

class notify_friendonline{
public:
	void decode(ByteArray	&);
	void ~notify_friendonline();
	void PacketName(void);
	void encode(ByteArray	&);
	void notify_friendonline(void);
	void build(ByteArray &);
}
#endif