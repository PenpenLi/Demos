#ifndef MOF_REQ_REALPVP_EXCHANGE_ITEMLIST_H
#define MOF_REQ_REALPVP_EXCHANGE_ITEMLIST_H

class req_realpvp_exchange_itemlist{
public:
	void ~req_realpvp_exchange_itemlist();
	void decode(ByteArray &);
	void PacketName(void);
	void req_realpvp_exchange_itemlist(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif