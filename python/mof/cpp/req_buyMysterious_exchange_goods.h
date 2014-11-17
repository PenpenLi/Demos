#ifndef MOF_REQ_BUYMYSTERIOUS_EXCHANGE_GOODS_H
#define MOF_REQ_BUYMYSTERIOUS_EXCHANGE_GOODS_H

class req_buyMysterious_exchange_goods{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_buyMysterious_exchange_goods(void);
	void ~req_buyMysterious_exchange_goods();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif