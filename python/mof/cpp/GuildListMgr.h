#ifndef MOF_GUILDLISTMGR_H
#define MOF_GUILDLISTMGR_H

class GuildListMgr{
public:
	void ackMyGuildRank(int);
	void ackGuildListData(std::vector<obj_guild_info, std::allocator<obj_guild_info>>, int);
	void getDataSize(void);
	void GuildListMgr(void);
	void reqGuildListData(int,int);
	void reqMyGuildRank(void);
	void ~GuildListMgr();
	void getGuildListDataByIndex(int);
	void reqGuildListData(int, int);
	void clearData(void);
	void ackSearchData(obj_guild_info);
	void ackGuildListData(std::vector<obj_guild_info,std::allocator<obj_guild_info>>,int);
}
#endif