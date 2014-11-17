#ifndef MOF_TREASUREFIGHTUI_H
#define MOF_TREASUREFIGHTUI_H

class TreasureFightUI{
public:
	void onMenuItemCloseRuleClicked(cocos2d::CCObject *);
	void setRemainActTimes(float);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ~TreasureFightUI();
	void onMenuItemQuickEnterClick(cocos2d::CCObject *);
	void onMenuItemOpenRuleClicked(cocos2d::CCObject *);
	void create(void);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onMenuItemChatClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void addRoomDatas(int, int);
	void initRoomViews(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void freshTime(int);
	void onMenuItemChatClick(cocos2d::CCObject	*);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setInfoData(void);
	void deleteAllDatas(void);
	void onEnter(void);
	void setResurgenceState(float);
	void TreasureFightUI(void);
	void onMenuItemCloseRuleClicked(cocos2d::CCObject	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void addRoomDatas(int,int);
	void init(void);
	void onExit(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
}
#endif