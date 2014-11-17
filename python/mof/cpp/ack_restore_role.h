#ifndef MOF_ACK_RESTORE_ROLE_H
#define MOF_ACK_RESTORE_ROLE_H

class ack_restore_role{
public:
	void ack_restore_role(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~ack_restore_role();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif