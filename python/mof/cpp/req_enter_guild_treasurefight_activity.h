#ifndef MOF_REQ_ENTER_GUILD_TREASUREFIGHT_ACTIVITY_H
#define MOF_REQ_ENTER_GUILD_TREASUREFIGHT_ACTIVITY_H

class req_enter_guild_treasurefight_activity{
public:
	void req_enter_guild_treasurefight_activity(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_enter_guild_treasurefight_activity();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif