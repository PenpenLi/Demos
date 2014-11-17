#ifndef MOF_GUILDPLAYERMGR_H
#define MOF_GUILDPLAYERMGR_H

class GuildPlayerMgr{
public:
	void jointAwardString(std::string);
	void ~GuildPlayerMgr();
	void GuildPlayerMgr(void);
	void ackGuildPlayerData(GuildPlayerData);
}
#endif