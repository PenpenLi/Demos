#ifndef MOF_CCACTIONMANAGER_H
#define MOF_CCACTIONMANAGER_H

class CCActionManager{
public:
	void removeActionByTag(unsigned int, cocos2d::CCObject *);
	void getActionByTag(unsigned int, cocos2d::CCObject *);
	void removeAction(cocos2d::CCAction *);
	void numberOfRunningActionsInTarget(cocos2d::CCObject *);
	void resumeTarget(cocos2d::CCObject *);
	void removeActionAtIndex(unsigned int, cocos2d::_hashElement *);
	void actionAllocWithHashElement(cocos2d::_hashElement *);
	void addAction(cocos2d::CCAction	*, cocos2d::CCNode *, bool);
	void deleteHashElement(cocos2d::_hashElement *);
	void removeAllActionsFromTarget(cocos2d::CCObject *);
	void getActionByTag(uint,cocos2d::CCObject *);
	void pauseTarget(cocos2d::CCObject *);
	void ~CCActionManager();
	void CCActionManager(void);
	void removeActionByTag(uint,cocos2d::CCObject *);
	void removeActionAtIndex(uint,cocos2d::_hashElement *);
	void update(float);
	void addAction(cocos2d::CCAction	*,cocos2d::CCNode *,bool);
}
#endif