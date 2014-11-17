#ifndef MOF_NOTIFY_BROADCAST_H
#define MOF_NOTIFY_BROADCAST_H

class notify_broadcast{
public:
	void decode(ByteArray &);
	void ~notify_broadcast();
	void PacketName(void);
	void notify_broadcast(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif