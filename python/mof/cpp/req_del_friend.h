#ifndef MOF_REQ_DEL_FRIEND_H
#define MOF_REQ_DEL_FRIEND_H

class req_del_friend{
public:
	void req_del_friend(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_del_friend();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif