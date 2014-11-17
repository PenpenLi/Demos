#ifndef MOF_TOTEMARRAYCONTAINER_H
#define MOF_TOTEMARRAYCONTAINER_H

class TotemArrayContainer{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void createArray(void);
	void onEnter(void);
	void ~TotemArrayContainer();
	void selFirst(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif