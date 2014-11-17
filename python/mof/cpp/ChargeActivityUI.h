#ifndef MOF_CHARGEACTIVITYUI_H
#define MOF_CHARGEACTIVITYUI_H

class ChargeActivityUI{
public:
	void getPageAward(void);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void getCurPageAward(void)const;
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void getAwardType(void)const;
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void setCurPageMenu(int);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void ~ChargeActivityUI();
	void getClickID(void);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setClickID(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setAwardType(int);
	void onMenuItemPreClicked(cocos2d::CCObject *);
	void setPageAward(int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setPageMenu(int);
	void onMenuItemNextClicked(cocos2d::CCObject	*);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void recvTouchEvent(void);
	void initContent(void);
	void refreshActivityContent(int);
	void getPageAward(void)const;
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void showActivityContent(void);
	void clearAll(void);
	void onMenuItemChargeClicked(cocos2d::CCObject *);
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void getAwardType(void);
	void ChargeActivityUI(void);
	void setCurPageAward(int);
	void onMenuItemNextClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void getCurPageAward(void);
	void init(void);
	void onExit(void);
}
#endif