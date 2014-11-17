#ifndef MOF_CONTINUEFLY_H
#define MOF_CONTINUEFLY_H

class ContinueFly{
public:
	void checkAttackFirst(float);
	void start(void);
	void end(float);
	void checkAttack(float);
	void ~ContinueFly();
	void perform(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif