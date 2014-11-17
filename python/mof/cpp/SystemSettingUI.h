#ifndef MOF_SYSTEMSETTINGUI_H
#define MOF_SYSTEMSETTINGUI_H

class SystemSettingUI{
public:
	void onMenuItemSwitchRolesClicked(cocos2d::CCObject *);
	void onMenuCustomMenuClicked(cocos2d::CCObject *);
	void InitControl(void);
	void onMenuUserCenterClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenubbsClicked(cocos2d::CCObject *);
	void onMenuItemLogBackInClicked(cocos2d::CCObject	*);
	void onMenuItemVolumeClicked(cocos2d::CCObject *);
	void ~SystemSettingUI();
	void setEfunCenterImageState(void);
	void onEnter(void);
	void onMenuItemLogBackInClicked(cocos2d::CCObject *);
	void onMenuItemHideRoleClicked(cocos2d::CCObject *);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void create(void);
	void init(void);
	void onExit(void);
	void onMenuItemMusicClicked(cocos2d::CCObject *);
}
#endif