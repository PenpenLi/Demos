#ifndef MOF_REQ_PLAYER_GUILD_DETAIL_H
#define MOF_REQ_PLAYER_GUILD_DETAIL_H

class req_player_guild_detail{
public:
	void req_player_guild_detail(void);
	void ~req_player_guild_detail();
	void decode(ByteArray &);
	void PacketName(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif