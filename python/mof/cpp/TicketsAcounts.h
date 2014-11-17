#ifndef MOF_TICKETSACOUNTS_H
#define MOF_TICKETSACOUNTS_H

class TicketsAcounts{
public:
	void setReceiveAward(std::string);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void onMenuItemFlop3Clicked(cocos2d::CCObject *);
	void onMenuItemGetChargeClicked(cocos2d::CCObject *);
	void onMenuItemCheckAward(cocos2d::CCObject *);
	void onMenuItemCheckCancel(cocos2d::CCObject *);
	void showFlopAnimation(std::string,int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void autoFlopCallBack(void);
	void onMenuItemGotoCityClicked(cocos2d::CCObject *);
	void closeCountdown(void);
	void onMenuItemGetTicketClicked(cocos2d::CCObject *);
	void showGetChargeByFlop(void);
	void showFlopAnimation(std::string, int);
	void TicketsAcounts(void);
	void onMenuItemCheckAward(cocos2d::CCObject	*);
	void readScoreAward(void);
	void autoFlopAll(void);
	void setAllCardEnable(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemFlop2Clicked(cocos2d::CCObject *);
	void onMenuItemCancelGotoCityClicked(cocos2d::CCObject *);
	void ~TicketsAcounts();
	void addAwardSpr(cocos2d::CCSprite	*, char	const*,	char const*);
	void onEnter(void);
	void addAwardSpr(cocos2d::CCSprite	*,char const*,char const*);
	void Init(void);
	void countdownCallBack(float);
	void getScoreRange(int);
	void setMenuItemCancelGotoCityEnable(bool);
	void create(void);
	void onMenuItemFlop1Clicked(cocos2d::CCObject *);
	void refreshLimitRecord(float);
	void onMenuItemFlop4Clicked(cocos2d::CCObject *);
	void btnEnableCallBack(void);
	void init(void);
	void onExit(void);
}
#endif