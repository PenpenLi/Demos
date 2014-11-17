#ifndef MOF_ACK_SYNC_SKILL_H
#define MOF_ACK_SYNC_SKILL_H

class ack_sync_skill{
public:
	void ~ack_sync_skill();
	void build(ByteArray &);
	void PacketName(void);
	void decode(ByteArray &);
	void ack_sync_skill(void);
	void encode(ByteArray &);
}
#endif