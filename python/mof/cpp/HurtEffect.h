#ifndef MOF_HURTEFFECT_H
#define MOF_HURTEFFECT_H

class HurtEffect{
public:
	void start(void);
	void endStrongly(void);
	void end(float);
	void perform(float);
	void ~HurtEffect();
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif