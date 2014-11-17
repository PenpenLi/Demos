#ifndef MOF_DAILYTASKUI_H
#define MOF_DAILYTASKUI_H

class DailyTaskUI{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemAcceptDailyTaskClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemReSetDailyTaskClicked(cocos2d::CCObject	*);
	void setgoldShow(int);
	void onMenuItemReSetDailyTaskClicked(cocos2d::CCObject *);
	void init(void);
	void ~DailyTaskUI();
	void setShowContent(void);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject	*);
	void onMenuItemGiveUpDailyTaskClicked(cocos2d::CCObject *);
	void onMenuItemGoDailyTaskClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void create(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onExit(void);
}
#endif