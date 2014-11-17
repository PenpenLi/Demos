#ifndef MOF_ACK_GET_ITEM_BY_CONSUM_PETPVP_POINT_H
#define MOF_ACK_GET_ITEM_BY_CONSUM_PETPVP_POINT_H

class ack_get_item_by_consum_petpvp_point{
public:
	void decode(ByteArray	&);
	void PacketName(void);
	void ~ack_get_item_by_consum_petpvp_point();
	void encode(ByteArray	&);
	void build(ByteArray &);
	void ack_get_item_by_consum_petpvp_point(void);
}
#endif