#ifndef MOF_REQ_BUYMYSTERIOUS_GOODS_H
#define MOF_REQ_BUYMYSTERIOUS_GOODS_H

class req_buyMysterious_goods{
public:
	void ~req_buyMysterious_goods();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void req_buyMysterious_goods(void);
}
#endif