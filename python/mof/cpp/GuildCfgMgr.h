#ifndef MOF_GUILDCFGMGR_H
#define MOF_GUILDCFGMGR_H

class GuildCfgMgr{
public:
	void getGuildSelfPresentDef(int);
	void getGadDef(int, int);
	void getImpeachCost(void);
	void getImpeachTime(void);
	void getGuildLvlDef(int);
	void getRemainGoodsSize(void);
	void RemainGoods(std::vector<int,std::allocator<int>>	&);
	void load(void);
	void loadGuildBossCfg(void);
	void getGuildBossLvlExp(int);
	void getSkillDef(int,	int);
	void getGuildBossUpLvlMaxExp(int);
	void getSkillIdVec(void);
	void getGuildBossLvlDef(int);
	void loadGuildBossKillCfg(IniFile &);
	void getGadDef(int,int);
	void RemainGoods(std::vector<int, std::allocator<int>> &);
	void getGuildLvlDef(float, int);
	void getGuildLvlDef(float,int);
	void getGuildPresentRmbDef(void);
	void getSkillDef(int,int);
}
#endif