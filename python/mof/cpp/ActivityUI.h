#ifndef MOF_ACTIVITYUI_H
#define MOF_ACTIVITYUI_H

class ActivityUI{
public:
	void showActivityDesc(ActivityCfgDef *);
	void playMySticMerchantUI(void);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void playLottery(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void playWorldBoss(void);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void create(void);
	void refreshTimer(float);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void playMakeprintCopy(void);
	void playTeamCopyWithFriends(void);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void playUnderCopy(void);
	void playPetMatch(void);
	void playUnderCopyWithFriend(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ~ActivityUI();
	void playPetCopy(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void setOpenActivity(std::vector<int,std::allocator<int>>);
	void setOpenActivity(std::vector<int, std::allocator<int>>);
	void goToTicketActivity(void);
	void playDefendStatue(void);
	void setActivittImageIsEnable(bool);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setRefreshActivityData(int,bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void playPetElitsCopy(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemGoToActivityClicked(cocos2d::CCObject *);
	void playpetUnder(void);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void ActivityUI(void);
	void playFamousHall(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void playDiceGame(void);
	void setRefreshActivityData(int, bool);
	void initCallback(void);
	void playDailyAnswer(void);
	void playTreasureFightCopy(void);
	void playMysticalCopy(void);
	void playPetArena(void);
	void init(void);
	void onExit(void);
	void onEnter(void);
}
#endif