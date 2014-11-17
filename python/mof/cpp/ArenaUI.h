#ifndef MOF_ARENAUI_H
#define MOF_ARENAUI_H

class ArenaUI{
public:
	void setData(int,std::vector<obj_pvp_role,std::allocator<obj_pvp_role>>,std::vector<obj_pvp_log,std::allocator<obj_pvp_log>>);
	void setArenaNum(int);
	void refreshEnemyDatas(std::vector<obj_pvp_role,std::allocator<obj_pvp_role>>);
	void createSortNode(std::vector<obj_pvp_log,std::allocator<obj_pvp_log>>,cocos2d::CCNode *);
	void setAward(int,int,int,int);
	void onMenuItemAwardClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void refreshEnemyDatas(std::vector<obj_pvp_role, std::allocator<obj_pvp_role>>);
	void onMenuItemRefreshClicked(cocos2d::CCObject *);
	void refreshCollingTimer(float);
	void starCollingTimer(int, int);
	void setData(int,	std::vector<obj_pvp_role, std::allocator<obj_pvp_role>>, std::vector<obj_pvp_log, std::allocator<obj_pvp_log>>);
	void ~ArenaUI();
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void resetCollingSuccess(void);
	void starCollingTimer(int,int);
	void onEnter(void);
	void setAward(int, int, int, int);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void createControl(int, obj_pvp_role, cocos2d::CCNode *);
	void createControl(int,obj_pvp_role,cocos2d::CCNode *);
	void create(void);
	void init(void);
	void onMenuItemCoolingClicked(cocos2d::CCObject *);
	void createSortNode(std::vector<obj_pvp_log, std::allocator<obj_pvp_log>>, cocos2d::CCNode *);
	void setCollingControlIsShow(bool);
	void onMenuItemRoleClicked(cocos2d::CCObject *);
	void onMenuItemAddNumClicked(cocos2d::CCObject *);
	void onExit(void);
}
#endif