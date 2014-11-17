#ifndef MOF_GUILDNEWSMGR_H
#define MOF_GUILDNEWSMGR_H

class GuildNewsMgr{
public:
	void GuildNewsMgr(void);
	void ~GuildNewsMgr();
	void ackGuildNewsData(std::vector<obj_guild_log_info,std::allocator<obj_guild_log_info>>,int);
	void getNewsSize(void);
	void getGuildNewsDataByIndex(int);
	void ackGuildNewsData(std::vector<obj_guild_log_info, std::allocator<obj_guild_log_info>>, int);
	void reqGuildNewsData(int,int);
	void clearData(void);
	void reqGuildNewsData(int, int);
}
#endif