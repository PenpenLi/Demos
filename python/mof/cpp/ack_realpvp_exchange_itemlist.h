#ifndef MOF_ACK_REALPVP_EXCHANGE_ITEMLIST_H
#define MOF_ACK_REALPVP_EXCHANGE_ITEMLIST_H

class ack_realpvp_exchange_itemlist{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_realpvp_exchange_itemlist();
	void ack_realpvp_exchange_itemlist(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif