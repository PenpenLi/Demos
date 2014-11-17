#ifndef MOF_KNOCKBACKACTION_H
#define MOF_KNOCKBACKACTION_H

class KnockBackAction{
public:
	void setOwner(LivingObject *);
	void start(void);
	void endStrongly(void);
	void end(float);
	void checkEnd(float);
	void ~KnockBackAction();
	void perform(float);
	void create(LivingObject *,LivingObject *,int,SkillEffectVal *);
}
#endif