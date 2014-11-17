#ifndef MOF_AUTOTESTUI_H
#define MOF_AUTOTESTUI_H

class AutoTestUI{
public:
	void onMenuItemEnDrawingCopyClicked(cocos2d::CCObject *);
	void goNextCopy(void);
	void getOpenScene(std::vector<int, std::allocator<int>>);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void dealWithComposeAckMsg(void);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void getCopyOperateTyeName(int);
	void onMenuItemDefendStatueClicked(cocos2d::CCObject *);
	void clearData(void);
	void create(void);
	void onMenuItemStrongCliecked(cocos2d::CCObject *);
	void setStrongEnable(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setMergeEnable(void);
	void onHandlePetElite(int, std::vector<int, std::allocator<int>>);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void onMenuItemBesetClicked(cocos2d::CCObject *);
	void onHandlePetElite(int,std::vector<int,std::allocator<int>>);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemAwardAccountClicked(cocos2d::CCObject *);
	void itemMerge(void);
	void AutoTestUI(void);
	void composeItem(void);
	void onMenuItemImproveTestClicked(cocos2d::CCObject *);
	void onMenuItemMergeClicked(cocos2d::CCObject *);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void addAward(std::vector<ItemGroup,std::allocator<ItemGroup>>,int,int,int,int,int);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void addAward(std::string);
	void dealWithAckMsg(void);
	void checkSkillType(int);
	void onMenuItemFamousHallClicked(cocos2d::CCObject *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void onMenuItemDailyStPvpClicked(cocos2d::CCObject *);
	void onMenuItemStrongCliecked(cocos2d::CCObject	*);
	void onMenuItemAntoFightingClicked(cocos2d::CCObject *);
	void strongItem(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void onMenuItemComposeClicked(cocos2d::CCObject	*);
	void getItemNameByTag(int);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onEnter(void);
	void onMenuItemEChangeMysticalCopyClicked(cocos2d::CCObject *);
	void onMenuItemPassiveSkillClicked(cocos2d::CCObject *);
	void onMenuItemComposeClicked(cocos2d::CCObject *);
	void onHandleGetFamousHallId(int, int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onMenuItemPetEliteClicked(cocos2d::CCObject *);
	void autoGuildSkill(void);
	void reqAutoTesttool(void);
	void onHandleGetFamousHallId(int,int);
	void onMenuItemStCopyClicked(cocos2d::CCObject	*);
	void onMenuItemStEliteCopyClicked(cocos2d::CCObject *);
	void onMenuItemStTeamCopyClicked(cocos2d::CCObject *);
	void onMenuItemGuildSkillClicked(cocos2d::CCObject *);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemTeamUndergroundCityClicked(cocos2d::CCObject *);
	void getStringFromInt(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onMenuItemDailyUndergroundCityClicked(cocos2d::CCObject *);
	void autoGetSkillStype(int);
	void ackDefendStatue(int);
	void mosaicItem(void);
	void onMenuItemActiveSkillClicked(cocos2d::CCObject *);
	void ~AutoTestUI();
	void addAward(std::vector<ItemGroup, std::allocator<ItemGroup>>, int, int, int, int, int);
	void onMenuItemTestReadyClicked(cocos2d::CCObject *);
	void getOpenScene(std::vector<int,std::allocator<int>>);
	void init(void);
	void onExit(void);
	void onMenuItemStCopyClicked(cocos2d::CCObject *);
}
#endif