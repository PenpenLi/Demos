#ifndef MOF_GUILDAPPLYMGR_H
#define MOF_GUILDAPPLYMGR_H

class GuildApplyMgr{
public:
	void getApplyByIndex(int);
	void clearData(void);
	void getApplySize(void);
	void ~GuildApplyMgr();
	void ackGuildApplyData(std::vector<obj_guild_applicant,std::allocator<obj_guild_applicant>>,int);
	void ackGuildApplyData(std::vector<obj_guild_applicant, std::allocator<obj_guild_applicant>>, int);
	void notifyGuildApply(void);
	void GuildApplyMgr(void);
	void reqGuildApplyData(int,int);
	void reqGuildApplyData(int,	int);
	void deleteApplyByRoleID(int);
}
#endif