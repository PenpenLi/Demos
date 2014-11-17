#ifndef MOF_CCSEQUENCE_H
#define MOF_CCSEQUENCE_H

class CCSequence{
public:
	void create(cocos2d::CCFiniteTimeAction *, ...);
	void stop(void);
	void createWithVariableList(cocos2d::CCFiniteTimeAction *,void *);
	void createWithTwoActions(cocos2d::CCFiniteTimeAction	*,cocos2d::CCFiniteTimeAction *);
	void ~CCSequence();
	void createWithVariableList(cocos2d::CCFiniteTimeAction *, void *);
	void copyWithZone(cocos2d::CCZone *);
	void create(cocos2d::CCFiniteTimeAction *,...);
	void startWithTarget(cocos2d::CCNode *);
	void reverse(void);
	void create(cocos2d::CCArray *);
	void update(float);
}
#endif