#ifndef MOF_SYNPVPUI_H
#define MOF_SYNPVPUI_H

class SynPvpUI{
public:
	void create(void);
	void onMenuItemMatchContenderClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void updateDeal(float);
	void onMenuItemStartMatchClicked(cocos2d::CCObject *);
	void onMenuItemSureExchange(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemCancelExchange(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void SynPvpUI(void);
	void showCompensation(int, int);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void updateTimeDown(float);
	void endTimeShow(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void createPanel(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemShopPageDnClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void initContent(void);
	void endRoleSelWithNone(bool);
	void showExchangeWindow(SynPvpStoreGoodsDef *);
	void revMatchResult(void);
	void refreshScroll(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setLockState(bool);
	void ~SynPvpUI();
	void refreshPanel(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void hideExchangeWindow(void);
	void onEnter(void);
	void showCompensation(int,int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemCancelMatchClicked(cocos2d::CCObject *);
	void onMenuItemExchangeMedalClicked(cocos2d::CCObject	*);
	void beginRoleSel(void);
	void createScroll(cocos2d::CCPoint);
	void endTimeHide(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemCloseCompensation(cocos2d::CCObject *);
	void onMenuItemShopPageUpClicked(cocos2d::CCObject *);
	void revCancelMatch(void);
	void onMenuItemExchangeMedalClicked(cocos2d::CCObject *);
	void setDealTimer(float);
	void showTimeDown(bool);
	void onMenuItemSureExchange(cocos2d::CCObject	*);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void setTimer(float);
	void init(void);
	void onExit(void);
}
#endif