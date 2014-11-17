#ifndef MOF_REQ_FINISH_FRIEND_DUNGE_H
#define MOF_REQ_FINISH_FRIEND_DUNGE_H

class req_finish_friend_dunge{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_finish_friend_dunge();
	void req_finish_friend_dunge(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif