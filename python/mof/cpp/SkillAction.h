#ifndef MOF_SKILLACTION_H
#define MOF_SKILLACTION_H

class SkillAction{
public:
	void calAttackArea(GameObject	*);
	void isExistSkillAction(int);
	void clearAllSkillAction(void);
	void clearSelf(void);
	void start(void);
	void endStrongly(void);
	void getSkillEffectIndex(void);
	void SkillAction(LivingObject	*,LivingObject *,int,SkillEffectVal *);
	void end(float);
	void castEnd(float);
	void getSkillID(void);
	void SkillAction(LivingObject	*, LivingObject	*, int,	SkillEffectVal *);
	void deleteOneInAllSkillActions(int);
	void perform(float);
	void ~SkillAction();
	void checkAttack(float);
}
#endif