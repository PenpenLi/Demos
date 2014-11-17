#ifndef MOF_CHARGEMENUCONTAINER_H
#define MOF_CHARGEMENUCONTAINER_H

class ChargeMenuContainer{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void ~ChargeMenuContainer();
	void onReceiveDragInsideClicked(cocos2d::CCObject	*);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void onEnter(void);
	void sendTouchEvent(cocos2d::CCNode *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void initContent(void);
}
#endif