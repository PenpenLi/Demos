#ifndef MOF_CCACTION_H
#define MOF_CCACTION_H

class CCAction{
public:
	void stop(void);
	void step(float);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void isDone(void);
	void CCAction(void);
	void ~CCAction();
}
#endif