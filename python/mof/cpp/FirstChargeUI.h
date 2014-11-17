#ifndef MOF_FIRSTCHARGEUI_H
#define MOF_FIRSTCHARGEUI_H

class FirstChargeUI{
public:
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void changeMenuState(bool);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void adjustVipInfo(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,	char const*, cocos2d::CCNode *);
	void showPetGive(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void onMenuItemLeftClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void FirstChargeUI(void);
	void ccTouchEnded(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onMenuItemRewardClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ~FirstChargeUI();
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void adjustScrollView(float);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void InitContent(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void ccTouchMoved(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void getVipAwardLvl(void);
	void getScrollRect(void);
	void onMenuItemChargeClicked(cocos2d::CCObject *);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif