#ifndef MOF_ACK_BUYMYSTERIOUS_EXCHANGE_LIST_H
#define MOF_ACK_BUYMYSTERIOUS_EXCHANGE_LIST_H

class ack_buyMysterious_exchange_list{
public:
	void ~ack_buyMysterious_exchange_list();
	void ack_buyMysterious_exchange_list(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif