#ifndef MOF_MONSTER_H
#define MOF_MONSTER_H

class Monster{
public:
	void FixAtkOrient(LivingObject *);
	void getFrequency(void);
	void MonsterTrack(LivingObject *,bool);
	void death(LivingObject *);
	void MonsterFallow(LivingObject *);
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void Monster(ObjType,int);
	void deleterefreshHpSchedule(void);
	void getActionPeriod(void)const;
	void MonsterEscape(LivingObject *);
	void damage(int,LivingObject *);
	void InitOtherAttributes(MonsterCfgDef *);
	void MonsterAIStart(void);
	void InitPatrol(void);
	void afterRefreshMonsterHPCallBack(int);
	void starIncrHP(void);
	void MonsterInit(int);
	void CalMinSkillRect(void);
	void MonsterTrack(LivingObject *,	bool);
	void animationHandler(BoneAniEventType, std::string, std::string,	bool);
	void getActionPeriod(void);
	void MonsterPatrol(void);
	void animationHandler(BoneAniEventType, std::string, std::string, bool);
	void MonsterAIStop(void);
	void refreshMonsterHP(float);
	void updateState(float);
	void setActionPeriod(float);
	void InitBasicAttributes(MonsterCfgDef *);
	void ~Monster();
	void setFrequency(int);
	void getFrequency(void)const;
	void MonsterHangAround(void);
	void MonsterCanAtk(LivingObject *);
	void MonsterCastSkill(LivingObject *);
	void damage(int, LivingObject *);
	void deleteSkillColdingCellList(void);
	void Monster(ObjType, int);
}
#endif