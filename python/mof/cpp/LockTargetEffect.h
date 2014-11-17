#ifndef MOF_LOCKTARGETEFFECT_H
#define MOF_LOCKTARGETEFFECT_H

class LockTargetEffect{
public:
	void calAttackArea(cocos2d::CCPoint);
	void ~LockTargetEffect();
	void start(void);
	void end(float);
	void checkAttack(float);
	void create(LivingObject	*,LivingObject *,int,SkillEffectVal *);
	void perform(float);
}
#endif