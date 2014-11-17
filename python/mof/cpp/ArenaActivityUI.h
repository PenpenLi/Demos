#ifndef MOF_ARENAACTIVITYUI_H
#define MOF_ARENAACTIVITYUI_H

class ArenaActivityUI{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void create(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ~ArenaActivityUI();
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void setRefreshActivityData(int,int);
	void InitData(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemArenaPVPClicked(cocos2d::CCObject *);
	void setRefreshActivityData(int, int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onMenuItemArenaPKClicked(cocos2d::CCObject *);
	void ArenaActivityUI(void);
	void init(void);
	void onExit(void);
}
#endif