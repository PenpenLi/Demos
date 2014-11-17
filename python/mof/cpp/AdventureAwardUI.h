#ifndef MOF_ADVENTUREAWARDUI_H
#define MOF_ADVENTUREAWARDUI_H

class AdventureAwardUI{
public:
	void onGetMoneyClicked(cocos2d::CCObject	*);
	void onGetMoneyClicked(cocos2d::CCObject *);
	void ~AdventureAwardUI();
	void setData(int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void create(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onExit(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void init(void);
	void showOpenSuccess(void);
	void onEnter(void);
}
#endif