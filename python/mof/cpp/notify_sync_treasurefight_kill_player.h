#ifndef MOF_NOTIFY_SYNC_TREASUREFIGHT_KILL_PLAYER_H
#define MOF_NOTIFY_SYNC_TREASUREFIGHT_KILL_PLAYER_H

class notify_sync_treasurefight_kill_player{
public:
	void ~notify_sync_treasurefight_kill_player();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_sync_treasurefight_kill_player(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif