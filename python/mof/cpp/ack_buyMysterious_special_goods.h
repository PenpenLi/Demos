#ifndef MOF_ACK_BUYMYSTERIOUS_SPECIAL_GOODS_H
#define MOF_ACK_BUYMYSTERIOUS_SPECIAL_GOODS_H

class ack_buyMysterious_special_goods{
public:
	void ack_buyMysterious_special_goods(void);
	void PacketName(void);
	void ~ack_buyMysterious_special_goods();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif