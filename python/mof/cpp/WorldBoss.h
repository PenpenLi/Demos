#ifndef MOF_WORLDBOSS_H
#define MOF_WORLDBOSS_H

class WorldBoss{
public:
	void damage(int, LivingObject *);
	void death(LivingObject	*);
	void damage(int,LivingObject *);
	void ~WorldBoss();
}
#endif