#ifndef MOF_NOTIFY_GUILD_CHAT_H
#define MOF_NOTIFY_GUILD_CHAT_H

class notify_guild_chat{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_guild_chat();
	void notify_guild_chat(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif