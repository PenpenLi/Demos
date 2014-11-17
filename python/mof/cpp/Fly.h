#ifndef MOF_FLY_H
#define MOF_FLY_H

class Fly{
public:
	void start(void);
	void end(float);
	void checkAttack(float);
	void perform(float);
	void ~Fly();
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif