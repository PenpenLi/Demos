#ifndef MOF_WORLDBOSSRESULTUI_H
#define MOF_WORLDBOSSRESULTUI_H

class WorldBossResultUI{
public:
	void setAwardItem(std::string);
	void onMenuItemCheckAward(cocos2d::CCObject *);
	void setShowDefendStatueResult(bool,int,int);
	void onMenuItemLeftAwardClicked(cocos2d::CCObject *);
	void onMenuItemGoCityClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setGuildBossShowContent(bool,int,int);
	void onMenuItemCheckCancel(cocos2d::CCObject *);
	void WorldBossResultUI(void);
	void ~WorldBossResultUI();
	void setShowContent(bool, std::string);
	void setreward(std::vector<ItemGroup, std::allocator<ItemGroup>>, int, int, int, int, int, int,	int, int, int);
	void setShowFamousResult(bool,int,int);
	void setShowFamousResult(bool, std::string);
	void setShowDefendStatueResult(bool, int, int);
	void createAwardButton(int,int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setShowContent(bool,std::string);
	void initAward(void);
	void onEnter(void);
	void setShowFamousResult(bool, int, int);
	void removeAwardButton(void);
	void onMenuItemRightAwardClicked(cocos2d::CCObject *);
	void setGuildBossShowContent(bool, int,	int);
	void setreward(std::vector<ItemGroup,std::allocator<ItemGroup>>,int,int,int,int,int,int,int,int,int);
	void setShowChallengeResult(bool,int,int,int,bool);
	void create(void);
	void createAwardSprAndNum(std::string, int);
	void createAwardSprAndNum(std::string,int);
	void setShowFamousResult(bool,std::string);
	void createAwardButton(int, int);
	void setShowChallengeResult(bool, int, int, int, bool);
	void init(void);
	void onExit(void);
}
#endif