#ifndef MOF_NOTIFY_GUILD_TREASUREFIGHT_DATA_CHANGE_H
#define MOF_NOTIFY_GUILD_TREASUREFIGHT_DATA_CHANGE_H

class notify_guild_treasurefight_data_change{
public:
	void ~notify_guild_treasurefight_data_change();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_guild_treasurefight_data_change(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif