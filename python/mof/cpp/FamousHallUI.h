#ifndef MOF_FAMOUSHALLUI_H
#define MOF_FAMOUSHALLUI_H

class FamousHallUI{
public:
	void onMenuItemCloseRuleClicked(cocos2d::CCObject *);
	void createRole(cocos2d::CCNode *, FamousData const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void onMenuItemGameRuleClicked(cocos2d::CCObject *);
	void clearRole(void);
	void createRole(cocos2d::CCNode *,FamousData	const*);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemPVPLogClicked(cocos2d::CCObject *);
	void clearAllData(void);
	void onAssignCCBMemberVariable(cocos2d::CCObject *, char const*, cocos2d::CCNode *);
	void initContent(void);
	void recvWaveSel(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ~FamousHallUI();
	void onMenuItemPVPRankClicked(cocos2d::CCObject *);
	void onEnter(void);
	void onMenuItemPVPGotoClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onAssignCCBMemberVariable(cocos2d::CCObject *,char const*,cocos2d::CCNode *);
	void create(void);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void FamousHallUI(void);
	void init(void);
	void onExit(void);
}
#endif