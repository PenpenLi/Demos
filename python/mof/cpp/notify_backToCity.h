#ifndef MOF_NOTIFY_BACKTOCITY_H
#define MOF_NOTIFY_BACKTOCITY_H

class notify_backToCity{
public:
	void notify_backToCity(void);
	void build(ByteArray &);
	void PacketName(void);
	void decode(ByteArray &);
	void ~notify_backToCity();
	void encode(ByteArray &);
}
#endif