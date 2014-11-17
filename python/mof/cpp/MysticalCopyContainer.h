#ifndef MOF_MYSTICALCOPYCONTAINER_H
#define MOF_MYSTICALCOPYCONTAINER_H

class MysticalCopyContainer{
public:
	void upEveryFreshTime(float);
	void initBossNode(cocos2d::CCNode *,MysticalCopyListCfgDef *,bool);
	void onDragInsideClicked(cocos2d::CCObject *);
	void onTouchUpInsideClicked(cocos2d::CCObject *);
	void initBossNode(cocos2d::CCNode *, MysticalCopyListCfgDef	*, bool);
	void onTouchDownClicked(cocos2d::CCObject *);
	void create(void);
	void onTouchUpOutsideClicked(cocos2d::CCObject *);
	void createContent(void);
	void ~MysticalCopyContainer();
	void onEnter(void);
	void freshTime(int);
	void createControl(void);
	void MysticalCopyContainer(void);
	void init(void);
	void onExit(void);
}
#endif