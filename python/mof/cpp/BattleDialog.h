#ifndef MOF_BATTLEDIALOG_H
#define MOF_BATTLEDIALOG_H

class BattleDialog{
public:
	void showDialog(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void onMenuItemDialogClicked(cocos2d::CCObject *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void BattleDialog(void);
	void ~BattleDialog();
	void create(void);
	void setContent(void);
	void onEnter(void);
	void setPersonPostion(bool);
	void init(void);
	void onExit(void);
}
#endif