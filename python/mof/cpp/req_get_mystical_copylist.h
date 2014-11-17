#ifndef MOF_REQ_GET_MYSTICAL_COPYLIST_H
#define MOF_REQ_GET_MYSTICAL_COPYLIST_H

class req_get_mystical_copylist{
public:
	void ~req_get_mystical_copylist();
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_mystical_copylist(void);
	void encode(ByteArray &);
	void build(ByteArray &);
}
#endif