#ifndef MOF_NOTIFY_GUILD_INFO_H
#define MOF_NOTIFY_GUILD_INFO_H

class notify_guild_info{
public:
	void ~notify_guild_info();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_guild_info(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif