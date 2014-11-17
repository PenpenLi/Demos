#ifndef MOF_ACK_ENTER_GUILD_TREASUREFIGHT_ACTIVITY_H
#define MOF_ACK_ENTER_GUILD_TREASUREFIGHT_ACTIVITY_H

class ack_enter_guild_treasurefight_activity{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_enter_guild_treasurefight_activity(void);
	void build(ByteArray &);
	void encode(ByteArray &);
	void ~ack_enter_guild_treasurefight_activity();
}
#endif