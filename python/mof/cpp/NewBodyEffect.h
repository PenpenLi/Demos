#ifndef MOF_NEWBODYEFFECT_H
#define MOF_NEWBODYEFFECT_H

class NewBodyEffect{
public:
	void start(void);
	void perform(float);
	void ~NewBodyEffect();
	void end(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif