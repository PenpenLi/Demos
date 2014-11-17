#ifndef MOF_REQ_BEGIN_FRIEND_DUNGE_H
#define MOF_REQ_BEGIN_FRIEND_DUNGE_H

class req_begin_friend_dunge{
public:
	void ~req_begin_friend_dunge();
	void decode(ByteArray &);
	void PacketName(void);
	void req_begin_friend_dunge(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif