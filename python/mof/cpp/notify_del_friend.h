#ifndef MOF_NOTIFY_DEL_FRIEND_H
#define MOF_NOTIFY_DEL_FRIEND_H

class notify_del_friend{
public:
	void notify_del_friend(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_del_friend();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif