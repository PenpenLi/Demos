#ifndef MOF_GUILDSKILLCFG_H
#define MOF_GUILDSKILLCFG_H

class GuildSkillCfg{
public:
	void getCfg(int,int);
	void ~GuildSkillCfg();
	void read(IniFile &);
	void getCfg(int, int);
}
#endif