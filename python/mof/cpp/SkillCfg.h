#ifndef MOF_SKILLCFG_H
#define MOF_SKILLCFG_H

class SkillCfg{
public:
	void calcBattlePropFromSkill(int,SkillAffectTargetType,SkillIncrBattle &);
	void GetEffectFuncByTargetType(int, int);
	void GetEffectFuncByTargetType(int,int);
	void calcBattlePropFromSkill(int, SkillAffectTargetType,	SkillIncrBattle	&);
	void parseChangedFields(SkillCfgDef *, std::string, int,	IniFile	*, IniFile *);
	void parseUnchangeFields(SkillCfgDef *, std::string, IniFile *, IniFile *);
	void getCfg(int,bool &);
	void getCfg(int,	bool &);
	void parseUnchangeFields(SkillCfgDef *,std::string,IniFile *,IniFile *);
	void clientLoad(std::string, std::string);
	void getCfg(int);
	void load(std::string,std::string);
	void clientLoad(std::string,std::string);
	void parseChangedFields(SkillCfgDef *,std::string,int,IniFile *,IniFile *);
	void loadOneSkillFromFile(int);
}
#endif