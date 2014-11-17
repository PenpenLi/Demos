#ifndef MOF_CCREVERSETIME_H
#define MOF_CCREVERSETIME_H

class CCReverseTime{
public:
	void create(cocos2d::CCFiniteTimeAction *);
	void stop(void);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void ~CCReverseTime();
	void startWithTarget(cocos2d::CCNode *);
	void reverse(void);
	void initWithAction(cocos2d::CCFiniteTimeAction *);
}
#endif