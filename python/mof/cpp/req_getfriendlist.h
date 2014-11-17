#ifndef MOF_REQ_GETFRIENDLIST_H
#define MOF_REQ_GETFRIENDLIST_H

class req_getfriendlist{
public:
	void ~req_getfriendlist();
	void req_getfriendlist(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif