#ifndef MOF_REQ_SELLITEM_H
#define MOF_REQ_SELLITEM_H

class req_sellitem{
public:
	void ~req_sellitem();
	void decode(ByteArray &);
	void PacketName(void);
	void req_sellitem(void);
	void build(ByteArray	&);
	void encode(ByteArray &);
}
#endif