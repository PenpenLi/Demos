#ifndef MOF_ATTACK_H
#define MOF_ATTACK_H

class Attack{
public:
	void ~Attack();
	void step(float);
	void startWithTarget(cocos2d::CCNode *);
	void isDone(void);
	void create(cocos2d::CCPoint,std::string);
	void Attack(void);
}
#endif