#ifndef MOF_MONTHCARDUI_H
#define MOF_MONTHCARDUI_H

class MonthCardUI{
public:
	void MonthCardUI(void);
	void ~MonthCardUI();
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void refreshDatas(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void create(void);
	void onMenuCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void Init(int);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuChargeClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void init(void);
	void onExit(void);
}
#endif