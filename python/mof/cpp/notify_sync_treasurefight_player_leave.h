#ifndef MOF_NOTIFY_SYNC_TREASUREFIGHT_PLAYER_LEAVE_H
#define MOF_NOTIFY_SYNC_TREASUREFIGHT_PLAYER_LEAVE_H

class notify_sync_treasurefight_player_leave{
public:
	void ~notify_sync_treasurefight_player_leave();
	void notify_sync_treasurefight_player_leave(void);
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif