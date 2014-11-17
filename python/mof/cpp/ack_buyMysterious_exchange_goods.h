#ifndef MOF_ACK_BUYMYSTERIOUS_EXCHANGE_GOODS_H
#define MOF_ACK_BUYMYSTERIOUS_EXCHANGE_GOODS_H

class ack_buyMysterious_exchange_goods{
public:
	void ack_buyMysterious_exchange_goods(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_buyMysterious_exchange_goods();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif