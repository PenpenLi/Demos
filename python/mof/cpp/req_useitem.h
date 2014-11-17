#ifndef MOF_REQ_USEITEM_H
#define MOF_REQ_USEITEM_H

class req_useitem{
public:
	void decode(ByteArray	&);
	void ~req_useitem();
	void PacketName(void);
	void req_useitem(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif