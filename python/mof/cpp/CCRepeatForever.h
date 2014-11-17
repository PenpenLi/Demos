#ifndef MOF_CCREPEATFOREVER_H
#define MOF_CCREPEATFOREVER_H

class CCRepeatForever{
public:
	void ~CCRepeatForever();
	void step(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void create(cocos2d::CCActionInterval *);
	void reverse(void);
	void isDone(void);
}
#endif