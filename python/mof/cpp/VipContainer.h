#ifndef MOF_VIPCONTAINER_H
#define MOF_VIPCONTAINER_H

class VipContainer{
public:
	void onPrePageTouchUpOutsideClicked(cocos2d::CCObject	*);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject	*);
	void ~VipContainer();
	void onDescAwardTouchUpOutsideClicked(cocos2d::CCObject *);
	void clickedAction(float);
	void onNextPageTouchUpInsideClicked(cocos2d::CCObject *);
	void onNextPageTouchUpOutsideClicked(cocos2d::CCObject *);
	void onPrePageTouchUpInsideClicked(cocos2d::CCObject	*);
	void onNextPageTouchUpInsideClicked(cocos2d::CCObject	*);
	void setDescTipShow(cocos2d::CCPoint,int);
	void setDescString(int);
	void onPrePageDragInsideClicked(cocos2d::CCObject *);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void onDescAwardDragInsideClicked(cocos2d::CCObject *);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject	*);
	void VipContainer(void);
	void createDescTip(void);
	void onEnter(void);
	void createControl(void);
	void onDescAwardTouchUpInsideClicked(cocos2d::CCObject *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void onNextPageDragInsideClicked(cocos2d::CCObject *);
	void create(void);
	void onPrePageTouchUpOutsideClicked(cocos2d::CCObject *);
	void onPrePageTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
	void setDescTipShow(cocos2d::CCPoint, int);
}
#endif