#ifndef MOF_NOTIFY_GUILD_NEW_MEMBER_H
#define MOF_NOTIFY_GUILD_NEW_MEMBER_H

class notify_guild_new_member{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ~notify_guild_new_member();
	void notify_guild_new_member(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif