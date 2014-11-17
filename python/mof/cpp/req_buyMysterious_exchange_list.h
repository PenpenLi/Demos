#ifndef MOF_REQ_BUYMYSTERIOUS_EXCHANGE_LIST_H
#define MOF_REQ_BUYMYSTERIOUS_EXCHANGE_LIST_H

class req_buyMysterious_exchange_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_buyMysterious_exchange_list(void);
	void ~req_buyMysterious_exchange_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif