#ifndef MOF_ACK_SELECT_ROLE_H
#define MOF_ACK_SELECT_ROLE_H

class ack_select_role{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_select_role();
	void ack_select_role(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif