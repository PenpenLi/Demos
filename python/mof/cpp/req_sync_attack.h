#ifndef MOF_REQ_SYNC_ATTACK_H
#define MOF_REQ_SYNC_ATTACK_H

class req_sync_attack{
public:
	void req_sync_attack(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~req_sync_attack();
}
#endif