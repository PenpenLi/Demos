#ifndef MOF_ACK_DEL_FRIEND_H
#define MOF_ACK_DEL_FRIEND_H

class ack_del_friend{
public:
	void ack_del_friend(void);
	void ~ack_del_friend();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif