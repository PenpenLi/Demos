#ifndef MOF_GUILDMEMBERMGR_H
#define MOF_GUILDMEMBERMGR_H

class GuildMemberMgr{
public:
	void getGuildMemberByid(int);
	void getMemberByIndex(int);
	void ackGuildMemberData(std::vector<obj_guild_member,std::allocator<obj_guild_member>>);
	void ackGuildMemberData(std::vector<obj_guild_member, std::allocator<obj_guild_member>>);
	void ~GuildMemberMgr();
	void GuildMemberMgr(void);
	void getMemberSize(void);
	void getGuildMemberList(void);
	void reqGuildMemberList(void);
	void clearData(void);
	void deleteMemberByRoleID(int);
}
#endif