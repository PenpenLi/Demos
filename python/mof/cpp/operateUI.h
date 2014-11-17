#ifndef MOF_OPERATEUI_H
#define MOF_OPERATEUI_H

class operateUI{
public:
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void operateUI(void);
	void create(void);
	void init(void);
	void ~operateUI();
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onExit(void);
}
#endif