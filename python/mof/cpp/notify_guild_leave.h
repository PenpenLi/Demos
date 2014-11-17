#ifndef MOF_NOTIFY_GUILD_LEAVE_H
#define MOF_NOTIFY_GUILD_LEAVE_H

class notify_guild_leave{
public:
	void ~notify_guild_leave();
	void decode(ByteArray &);
	void PacketName(void);
	void notify_guild_leave(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif