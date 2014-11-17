#ifndef MOF_ACK_GET_MYSTICAL_COPYLIST_H
#define MOF_ACK_GET_MYSTICAL_COPYLIST_H

class ack_get_mystical_copylist{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_get_mystical_copylist(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_get_mystical_copylist();
}
#endif