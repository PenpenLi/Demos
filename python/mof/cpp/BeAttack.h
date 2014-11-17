#ifndef MOF_BEATTACK_H
#define MOF_BEATTACK_H

class BeAttack{
public:
	void ~BeAttack();
	void BeAttack(void);
	void step(float);
	void startWithTarget(cocos2d::CCNode *);
	void isDone(void);
	void create(cocos2d::CCPoint,std::string);
}
#endif