#ifndef MOF_REQ_EDIT_PETPVP_FORMATION_H
#define MOF_REQ_EDIT_PETPVP_FORMATION_H

class req_edit_petpvp_formation{
public:
	void req_edit_petpvp_formation(void);
	void PacketName(void);
	void ~req_edit_petpvp_formation();
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif