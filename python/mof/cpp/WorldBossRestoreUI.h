#ifndef MOF_WORLDBOSSRESTOREUI_H
#define MOF_WORLDBOSSRESTOREUI_H

class WorldBossRestoreUI{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void refreshTimer(float);
	void onMenuItemRestoreClicked(cocos2d::CCObject *);
	void onEnter(void);
	void onMenuItemRestoreClicked(cocos2d::CCObject	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void ~WorldBossRestoreUI();
	void init(void);
	void onExit(void);
}
#endif