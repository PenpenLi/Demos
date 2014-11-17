#ifndef MOF_MOVABLENEWBODYATTACKEFFECT_H
#define MOF_MOVABLENEWBODYATTACKEFFECT_H

class MovableNewBodyAttackEffect{
public:
	void start(void);
	void ~MovableNewBodyAttackEffect();
	void perform(float);
	void end(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif