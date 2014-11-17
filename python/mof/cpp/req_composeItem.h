#ifndef MOF_REQ_COMPOSEITEM_H
#define MOF_REQ_COMPOSEITEM_H

class req_composeItem{
public:
	void ~req_composeItem();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_composeItem(void);
}
#endif