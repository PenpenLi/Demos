#ifndef MOF_REQ_GET_ITEM_BY_CONSUM_PETPVP_POINT_H
#define MOF_REQ_GET_ITEM_BY_CONSUM_PETPVP_POINT_H

class req_get_item_by_consum_petpvp_point{
public:
	void decode(ByteArray	&);
	void ~req_get_item_by_consum_petpvp_point();
	void PacketName(void);
	void encode(ByteArray	&);
	void req_get_item_by_consum_petpvp_point(void);
	void build(ByteArray &);
}
#endif