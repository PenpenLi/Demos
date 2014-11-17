#ifndef MOF_ACK_DELETE_ROLE_H
#define MOF_ACK_DELETE_ROLE_H

class ack_delete_role{
public:
	void ack_delete_role(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_delete_role();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif