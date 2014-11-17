#ifndef MOF_ACTIVITYCONTAINER_H
#define MOF_ACTIVITYCONTAINER_H

class ActivityContainer{
public:
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject	*);
	void createActivityNode(cocos2d::CCNode	*,ActivityCfgDef *,bool);
	void ~ActivityContainer();
	void createActivityNode(cocos2d::CCNode	*, ActivityCfgDef *, bool);
	void ActivityContainer(void);
	void onDescAwardTouchDownClicked(cocos2d::CCObject *);
	void createContent(void);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void createEffect(cocos2d::CCNode *);
	void onEnter(void);
	void createControl(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif