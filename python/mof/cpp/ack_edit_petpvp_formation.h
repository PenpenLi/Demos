#ifndef MOF_ACK_EDIT_PETPVP_FORMATION_H
#define MOF_ACK_EDIT_PETPVP_FORMATION_H

class ack_edit_petpvp_formation{
public:
	void decode(ByteArray &);
	void ack_edit_petpvp_formation(void);
	void PacketName(void);
	void ~ack_edit_petpvp_formation();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif