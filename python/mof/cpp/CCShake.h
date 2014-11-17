#ifndef MOF_CCSHAKE_H
#define MOF_CCSHAKE_H

class CCShake{
public:
	void create(float,cocos2d::CCPoint,float,float);
	void stop(void);
	void step(float);
	void update(float);
	void startWithTarget(cocos2d::CCNode *);
	void create(float,cocos2d::CCPoint,float,float,float);
	void ~CCShake();
	void create(float);
}
#endif