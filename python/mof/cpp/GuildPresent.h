#ifndef MOF_GUILDPRESENT_H
#define MOF_GUILDPRESENT_H

class GuildPresent{
public:
	void ackPresent(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void onMenuItemPresentGoldClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemPresentDiamondClick(cocos2d::CCObject	*);
	void isShow(void);
	void refreshPresentGoldAndRmb(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemPresentBatClick(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onMenuItemCloseClick(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemFirstPresentClick(cocos2d::CCObject *);
	void onMenuItemPresentDiamondClick(cocos2d::CCObject *);
	void showRmbTimes(void);
	void onEnter(void);
	void GuildPresent(void);
	void ~GuildPresent();
	void create(void);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void init(void);
	void onExit(void);
}
#endif