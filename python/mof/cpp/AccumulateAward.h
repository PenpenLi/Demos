#ifndef MOF_ACCUMULATEAWARD_H
#define MOF_ACCUMULATEAWARD_H

class AccumulateAward{
public:
	void ccTouchDownClicked(cocos2d::CCObject	*);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void create(void);
	void onMenuItem3DayAward(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setDay5ImageState(bool);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchDownClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setDay7ImageState(bool);
	void onMenuItem7DayAward(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItem5DayAward(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItem3DayAward(cocos2d::CCObject	*);
	void ~AccumulateAward();
	void initShowTotalReward(void);
	void ccTouchTouchUpInsideClicked(cocos2d::CCObject	*);
	void setDesc(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchTouchUpOutsideClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItem7DayAward(cocos2d::CCObject	*);
	void onMenuItem5DayAward(cocos2d::CCObject	*);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ccTouchTouchUpInsideClicked(cocos2d::CCObject *);
	void setNumState(void);
	void setAwardDes(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setDay3ImageState(bool);
	void createControlButton(void);
	void AccumulateAward(void);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif