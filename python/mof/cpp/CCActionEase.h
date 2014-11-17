#ifndef MOF_CCACTIONEASE_H
#define MOF_CCACTIONEASE_H

class CCActionEase{
public:
	void stop(void);
	void create(cocos2d::CCActionInterval *);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void ~CCActionEase();
	void startWithTarget(cocos2d::CCNode *);
	void initWithAction(cocos2d::CCActionInterval *);
	void reverse(void);
}
#endif