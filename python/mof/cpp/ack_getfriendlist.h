#ifndef MOF_ACK_GETFRIENDLIST_H
#define MOF_ACK_GETFRIENDLIST_H

class ack_getfriendlist{
public:
	void ~ack_getfriendlist();
	void decode(ByteArray &);
	void PacketName(void);
	void ack_getfriendlist(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif