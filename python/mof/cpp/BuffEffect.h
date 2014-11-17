#ifndef MOF_BUFFEFFECT_H
#define MOF_BUFFEFFECT_H

class BuffEffect{
public:
	void ~BuffEffect();
	void start(void);
	void intervalBufCheck(void);
	void end(float);
	void endStrongly(void);
	void perform(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif