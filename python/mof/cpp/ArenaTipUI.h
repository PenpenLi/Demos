#ifndef MOF_ARENATIPUI_H
#define MOF_ARENATIPUI_H

class ArenaTipUI{
public:
	void setData(bool, int, int);
	void ~ArenaTipUI();
	void onMenuItemGoCityClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setSynPvpData(bool,int,int);
	void setSynPvpData(bool, int, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void setPetArenaData(bool,int,int);
	void setPetArenaData(bool, int, int);
	void onEnter(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void setData(bool,int,int);
	void init(void);
	void onExit(void);
	void onMenuItemGoCityClicked(cocos2d::CCObject	*);
}
#endif