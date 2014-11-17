#ifndef MOF_REQ_GET_PETPVP_FORMATION_H
#define MOF_REQ_GET_PETPVP_FORMATION_H

class req_get_petpvp_formation{
public:
	void ~req_get_petpvp_formation();
	void decode(ByteArray &);
	void PacketName(void);
	void req_get_petpvp_formation(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif