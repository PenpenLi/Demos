#ifndef MOF_STATICEFFECT_H
#define MOF_STATICEFFECT_H

class StaticEffect{
public:
	void start(void);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal	*);
	void end(float);
	void perform(float);
	void ~StaticEffect();
}
#endif