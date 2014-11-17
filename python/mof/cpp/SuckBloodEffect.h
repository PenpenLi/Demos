#ifndef MOF_SUCKBLOODEFFECT_H
#define MOF_SUCKBLOODEFFECT_H

class SuckBloodEffect{
public:
	void intervalCheck(float);
	void start(void);
	void endStrongly(void);
	void ~SuckBloodEffect();
	void end(float);
	void perform(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif