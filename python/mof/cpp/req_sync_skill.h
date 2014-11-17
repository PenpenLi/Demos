#ifndef MOF_REQ_SYNC_SKILL_H
#define MOF_REQ_SYNC_SKILL_H

class req_sync_skill{
public:
	void decode(ByteArray &);
	void ~req_sync_skill();
	void PacketName(void);
	void req_sync_skill(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif