#ifndef MOF_NOTIFY_PLAYER_GUILD_DETAIL_H
#define MOF_NOTIFY_PLAYER_GUILD_DETAIL_H

class notify_player_guild_detail{
public:
	void notify_player_guild_detail(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_player_guild_detail();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif