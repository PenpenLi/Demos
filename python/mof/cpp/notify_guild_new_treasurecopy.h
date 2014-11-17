#ifndef MOF_NOTIFY_GUILD_NEW_TREASURECOPY_H
#define MOF_NOTIFY_GUILD_NEW_TREASURECOPY_H

class notify_guild_new_treasurecopy{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_guild_new_treasurecopy();
	void notify_guild_new_treasurecopy(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif