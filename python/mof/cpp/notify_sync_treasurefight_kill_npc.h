#ifndef MOF_NOTIFY_SYNC_TREASUREFIGHT_KILL_NPC_H
#define MOF_NOTIFY_SYNC_TREASUREFIGHT_KILL_NPC_H

class notify_sync_treasurefight_kill_npc{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_treasurefight_kill_npc(void);
	void ~notify_sync_treasurefight_kill_npc();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif