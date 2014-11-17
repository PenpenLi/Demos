#ifndef MOF_GUILDGADCFG_H
#define MOF_GUILDGADCFG_H

class GuildGadCfg{
public:
	void getCfg(int,int);
	void ~GuildGadCfg();
	void read(IniFile &);
	void getCfg(int, int);
}
#endif