#ifndef MOF_ACK_BEGIN_FRIEND_DUNGE_H
#define MOF_ACK_BEGIN_FRIEND_DUNGE_H

class ack_begin_friend_dunge{
public:
	void ~ack_begin_friend_dunge();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_begin_friend_dunge(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif