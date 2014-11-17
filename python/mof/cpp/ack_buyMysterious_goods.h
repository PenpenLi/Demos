#ifndef MOF_ACK_BUYMYSTERIOUS_GOODS_H
#define MOF_ACK_BUYMYSTERIOUS_GOODS_H

class ack_buyMysterious_goods{
public:
	void ack_buyMysterious_goods(void);
	void ~ack_buyMysterious_goods();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif