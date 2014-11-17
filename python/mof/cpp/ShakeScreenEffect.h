#ifndef MOF_SHAKESCREENEFFECT_H
#define MOF_SHAKESCREENEFFECT_H

class ShakeScreenEffect{
public:
	void create(LivingObject *,int,SkillEffectVal *);
	void start(void);
	void perform(float);
	void end(float);
	void ~ShakeScreenEffect();
}
#endif