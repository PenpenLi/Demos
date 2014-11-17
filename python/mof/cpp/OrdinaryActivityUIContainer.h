#ifndef MOF_ORDINARYACTIVITYUICONTAINER_H
#define MOF_ORDINARYACTIVITYUICONTAINER_H

class OrdinaryActivityUIContainer{
public:
	void OrdinaryActivityUIContainer(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject	*);
	void createActivityNode(cocos2d::CCNode *,OrdinaryActivityCfgDef *);
	void onDescAwardTouchDownClicked(cocos2d::CCObject *);
	void createContent(void);
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void getWorldPointByTag(int,int &,bool &);
	void onEnter(void);
	void create(void);
	void createControl(void);
	void createActivityNode(cocos2d::CCNode *, OrdinaryActivityCfgDef *);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void ~OrdinaryActivityUIContainer();
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif