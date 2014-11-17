#ifndef MOF_NOTIFY_DUNGRESETTIMES_H
#define MOF_NOTIFY_DUNGRESETTIMES_H

class notify_dungResetTimes{
public:
	void notify_dungResetTimes(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~notify_dungResetTimes();
}
#endif