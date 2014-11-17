#ifndef MOF_SYNPVPCONTAINER_H
#define MOF_SYNPVPCONTAINER_H

class SynPvpContainer{
public:
	void createShop(void);
	void onDescTouchDownClicked(cocos2d::CCObject	*);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void onDescTouchDownClicked(cocos2d::CCObject *);
	void create(void);
	void ~SynPvpContainer();
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void onEnter(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject	*);
	void init(void);
	void onExit(void);
}
#endif