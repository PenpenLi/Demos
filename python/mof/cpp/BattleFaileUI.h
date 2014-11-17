#ifndef MOF_BATTLEFAILEUI_H
#define MOF_BATTLEFAILEUI_H

class BattleFaileUI{
public:
	void BattleFaileUI(void);
	void onMenuItemGoCityClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setTreasureFightDetail(std::string);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*,char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setValue(std::string,int);
	void setValueForSynPvp(bool);
	void onMenuItemsGoLifeClicked(cocos2d::CCObject *);
	void onEnter(void);
	void create(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject	*, char	const*);
	void setValue(std::string, int);
	void ~BattleFaileUI();
	void init(void);
	void onExit(void);
}
#endif