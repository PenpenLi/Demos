#ifndef MOF_PETMATCHUI_H
#define MOF_PETMATCHUI_H

class PetMatchUI{
public:
	void onMenuItemThiefHandClicked(cocos2d::CCObject *);
	void ~PetMatchUI();
	void setAllLabel(cocos2d::CCNode *);
	void initPetMatchData(std::vector<std::string,std::allocator<std::string>>,std::vector<int,std::allocator<int>>,int,int,int);
	void onMenuItemPledgeCloseClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*,char const*,cocos2d::CCNode *);
	void setPetLogoUnClick(int);
	void onMenuItemInfoCloseClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void onMenuItemPledgeDiamondThr(cocos2d::CCObject *);
	void activityNoStart(void);
	void firstFinal(int,cocos2d::CCMenu *,std::string,int,int,int);
	void onMenuItemPledgeDiamondTwo(cocos2d::CCObject *);
	void changePetStartTime(void);
	void setTime(std::vector<int, std::allocator<int>>);
	void petCasinoThief(int);
	void onMenuItemPledgeGoldThr(cocos2d::CCObject	*);
	void secondFinal(int,cocos2d::CCMenu *,std::string,int,int,int);
	void onAssignCCBMemberVariable(cocos2d::CCObject	*, char	const*,	cocos2d::CCNode	*);
	void secondFinal(int, cocos2d::CCMenu *, std::string, int, int, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemPledgeDiamondOne(cocos2d::CCObject *);
	void initData(void);
	void onMenuItemPledgeGoldThr(cocos2d::CCObject *);
	void noActivity(void);
	void PetMatchUI(void);
	void setCurrentLabel(cocos2d::CCNode *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemMatchRuleClicked(cocos2d::CCObject *);
	void forthFinal(int,cocos2d::CCMenu *,std::string,int,int,int);
	void distroyPetMatch(void);
	void forthFinal(int, cocos2d::CCMenu *, std::string, int, int,	int);
	void petCasinoWager(int, int, int);
	void initPetMatchPledge(ActivityPetCosinoWagerLevel *);
	void setTime(std::vector<int,std::allocator<int>>);
	void initPet(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void reqCurrentHistory(void);
	void createSomeLaberTTF(CasinoPet *, int);
	void createSomeLaberTTF(CasinoPet *,int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onItemTouchUpInsideClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void thirdFinal(int,cocos2d::CCMenu *,std::string,int,int,int);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void onMenuItemPledgeGoldTwo(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void onMenuItemCancel(void);
	void onMenuItemOK(void);
	void petCasinoWager(int,int,int);
	void onMenuItemPledgeGoldTwo(cocos2d::CCObject *);
	void initPetMatchData(std::vector<std::string,	std::allocator<std::string>>, std::vector<int, std::allocator<int>>, int, int, int);
	void create(void);
	void thirdFinal(int, cocos2d::CCMenu *, std::string, int, int,	int);
	void setThiefValue(int);
	void firstFinal(int, cocos2d::CCMenu *, std::string, int, int,	int);
	void onMenuItemPledgeGoldOne(cocos2d::CCObject *);
	void setCurrentActionType(void);
	void onMenuItemPledgeGoldOne(cocos2d::CCObject	*);
	void unSchedule(void);
	void setIsAlreadyShow(void);
	void init(void);
	void onExit(void);
}
#endif