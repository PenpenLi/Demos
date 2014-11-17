#ifndef MOF_ACK_BUYMYSTERIOUS_SPECIAL_LIST_H
#define MOF_ACK_BUYMYSTERIOUS_SPECIAL_LIST_H

class ack_buyMysterious_special_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_buyMysterious_special_list(void);
	void ~ack_buyMysterious_special_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif