#ifndef MOF_ACK_SYNC_ATTACK_H
#define MOF_ACK_SYNC_ATTACK_H

class ack_sync_attack{
public:
	void ~ack_sync_attack();
	void PacketName(void);
	void ack_sync_attack(void);
	void decode(ByteArray &);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif