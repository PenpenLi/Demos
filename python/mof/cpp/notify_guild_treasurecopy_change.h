#ifndef MOF_NOTIFY_GUILD_TREASURECOPY_CHANGE_H
#define MOF_NOTIFY_GUILD_TREASURECOPY_CHANGE_H

class notify_guild_treasurecopy_change{
public:
	void decode(ByteArray &);
	void notify_guild_treasurecopy_change(void);
	void PacketName(void);
	void ~notify_guild_treasurecopy_change();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif