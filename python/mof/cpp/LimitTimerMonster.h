#ifndef MOF_LIMITTIMERMONSTER_H
#define MOF_LIMITTIMERMONSTER_H

class LimitTimerMonster{
public:
	void ~LimitTimerMonster();
	void animationHandler(BoneAniEventType,	std::string, std::string, bool);
	void damage(int,LivingObject *);
	void LimitTimerMonster(ObjType,int,int);
	void death(LivingObject	*);
	void animationHandler(BoneAniEventType, std::string, std::string,	bool);
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void damage(int, LivingObject *);
}
#endif