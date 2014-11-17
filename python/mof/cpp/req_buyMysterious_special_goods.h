#ifndef MOF_REQ_BUYMYSTERIOUS_SPECIAL_GOODS_H
#define MOF_REQ_BUYMYSTERIOUS_SPECIAL_GOODS_H

class req_buyMysterious_special_goods{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_buyMysterious_special_goods(void);
	void ~req_buyMysterious_special_goods();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif