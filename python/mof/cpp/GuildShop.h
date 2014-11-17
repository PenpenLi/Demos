#ifndef MOF_GUILDSHOP_H
#define MOF_GUILDSHOP_H

class GuildShop{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemRightClick(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(void);
	void onMenuItemBuyOK(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void refreshPersonContirbute(void);
	void setFreshImageState(bool);
	void showPromptMsg(std::string);
	void onMenuItemLeftClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ~GuildShop();
	void onMenuItemBuyCancel(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void showActivityDesc(GuildShopData *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void removeCommonDialogUI(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char	const*,cocos2d::CCNode *);
	void upShopList(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void buyGoodsSuccess(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getRemainingTimes(int);
	void onMenuItemFreshOK(void);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void setClickedImageShow(bool);
	void onMenuItemPresentClick(cocos2d::CCObject *);
	void showFreshMenuLabl(void);
	void onMenuItemFreshCancel(void);
	void reqShopList(void);
	void refreshGoldAndRmb(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void refreshTimer(int);
	void GuildShop(void);
	void changeUpdateTime(void);
	void onMenuItemRefreshClick(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif