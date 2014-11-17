#ifndef MOF_RUSH_H
#define MOF_RUSH_H

class Rush{
public:
	void start(void);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal	*);
	void end(float);
	void perform(float);
	void ~Rush();
}
#endif