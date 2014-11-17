#ifndef MOF_GUILDPRESENTCFG_H
#define MOF_GUILDPRESENTCFG_H

class GuildPresentCfg{
public:
	void read(IniFile	&);
	void ~GuildPresentCfg();
	void getPresentCfg(int);
}
#endif