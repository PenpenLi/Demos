#ifndef MOF_TICKETACTIVITYUI_H
#define MOF_TICKETACTIVITYUI_H

class TicketActivityUI{
public:
	void ccTouchMoved(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemGotoCopyClicked(cocos2d::CCObject	*);
	void create(void);
	void getActivityID(void);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void destroyAwardScroll(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void getTicketCount(int);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void getMapID(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void showDownSpr(bool);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setAwardDialogShow(int);
	void ~TicketActivityUI();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void setActivityTitle(void);
	void ccTouchEnded(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void showUpSpr(bool);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void getActivityID(void)const;
	void onEnter(void);
	void ccTouchMoved(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void onMenuItemGotoCopyClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void onMenuItemDialogCloseClicked(cocos2d::CCObject *);
	void TicketActivityUI(void);
	void setActivityID(int);
	void setMapID(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void getMapID(void)const;
	void playLimitActivity(void);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif