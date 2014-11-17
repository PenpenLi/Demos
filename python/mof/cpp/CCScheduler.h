#ifndef MOF_CCSCHEDULER_H
#define MOF_CCSCHEDULER_H

class CCScheduler{
public:
	void unscheduleAllForTarget(cocos2d::CCObject *);
	void ~CCScheduler();
	void appendIn(cocos2d::_listEntry **,cocos2d::CCObject *,bool);
	void resumeTarget(cocos2d::CCObject *);
	void scheduleSelector(float),cocos2d::CCObject*,float,uint,float,bool);
	void unscheduleSelector(float),cocos2d::CCObject*);
	void appendIn(cocos2d::_listEntry **, cocos2d::CCObject *, bool);
	void priorityIn(cocos2d::_listEntry **,cocos2d::CCObject *,int,bool);
	void unscheduleAll(void);
	void removeHashElement(cocos2d::_hashSelectorEntry *);
	void unscheduleAllWithMinPriority(int);
	void scheduleUpdateForTarget(cocos2d::CCObject *, int, bool);
	void scheduleUpdateForTarget(cocos2d::CCObject *,int,bool);
	void pauseTarget(cocos2d::CCObject *);
	void update(float);
	void priorityIn(cocos2d::_listEntry **, cocos2d::CCObject *,	int, bool);
	void unscheduleUpdateForTarget(cocos2d::CCObject const*);
	void CCScheduler(void);
	void removeUpdateFromHash(cocos2d::_listEntry *);
	void scheduleSelector(float, int, float,	int);
}
#endif