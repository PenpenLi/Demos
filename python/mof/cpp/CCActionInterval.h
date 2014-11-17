#ifndef MOF_CCACTIONINTERVAL_H
#define MOF_CCACTIONINTERVAL_H

class CCActionInterval{
public:
	void initWithDuration(float);
	void ~CCActionInterval();
	void step(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void isDone(void);
	void reverse(void);
}
#endif