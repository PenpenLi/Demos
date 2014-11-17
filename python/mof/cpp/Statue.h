#ifndef MOF_STATUE_H
#define MOF_STATUE_H

class Statue{
public:
	void ~Statue();
	void defendStatueTimer(float);
	void damage(int,LivingObject *);
	void Statue(ObjType,int);
	void startDefendStatueTimer(void);
	void stopDefendStatueTimer(void);
	void Statue(ObjType, int);
	void death(LivingObject *);
	void damage(int, LivingObject *);
	void hittedLight(LivingObject *);
}
#endif