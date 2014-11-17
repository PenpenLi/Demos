#ifndef MOF_LIMITTIMERMGR_H
#define MOF_LIMITTIMERMGR_H

class LimitTimerMgr{
public:
	void notifyRefreshMonsters(std::vector<obj_tlk_monster, std::allocator<obj_tlk_monster>>);
	void getRandBoxItems(ItemCfgDef *, std::string, std::vector<std::string, std::allocator<std::string>> &);
	void compareItemById(ItemGroup, ItemGroup);
	void ackEnterLimitTimerCopy(int, int, int, std::vector<obj_tlk_monster, std::allocator<obj_tlk_monster>>);
	void clearPreloadMonsterXmls(void);
	void ackEnterLimitTimerCopy(int,int,int,std::vector<obj_tlk_monster,std::allocator<obj_tlk_monster>>);
	void checkAwardIsEqual(std::string,std::string);
	void checkItemIsEqual(std::vector<ItemGroup,std::allocator<ItemGroup>>,std::vector<ItemGroup,std::allocator<ItemGroup>>);
	void getMonsterRandomPosInArea(cocos2d::CCRect);
	void reqEnterLimitTimerCopy(int,int);
	void notifyRefreshMonsters(std::vector<obj_tlk_monster,std::allocator<obj_tlk_monster>>);
	void reqLeaveLimitTimerCopy(LeaveTlkCopyType);
	void ackKillLimitTimerMonsters(int,	int, int);
	void getKillsCount(void)const;
	void getScore(void);
	void setKillsCount(int);
	void getGameTimer(void)const;
	void createLimitTimerMonster(obj_tlk_monster,cocos2d::CCRect);
	void LimitTimerMgr(void);
	void reqkillLimitTimerMonsters(int,int);
	void reqkillLimitTimerMonsters(int,	int);
	void getKillsCount(void);
	void ackKillLimitTimerMonsters(int,int,int);
	void getGameTimer(void);
	void setScore(int);
	void setMonsterOrientation(LimitTimerMonster *);
	void reqEnterLimitTimerCopy(int, int);
	void getRandBoxItems(ItemCfgDef *,std::string,std::vector<std::string,std::allocator<std::string>> &);
	void checkAwardIsEqual(std::string,	std::string);
	void checkItemIsEqual(std::vector<ItemGroup, std::allocator<ItemGroup>>, std::vector<ItemGroup, std::allocator<ItemGroup>>);
	void createLimitTimerMonster(obj_tlk_monster, cocos2d::CCRect);
	void getScore(void)const;
	void compareItemById(ItemGroup,ItemGroup);
	void setGameTimer(int);
}
#endif